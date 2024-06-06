(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: Basic
 * File: basicCyclic.st
 * Author: Bernecker + Rainer
 * Created: December 01, 2009
 ********************************************************************
 * Implementation of Program Basic
 ********************************************************************)
PROGRAM _CYCLIC

(***************************************************************
        Control Sequence
***************************************************************)
(* status information is read before the step sequencer to attain a shorter reaction time *)
(************************ MC_READSTATUS *************************)
MC_ReadStatus_0.Enable := NOT(MC_ReadStatus_0.Error);
MC_ReadStatus_0.Axis := Axis1Obj;
MC_ReadStatus_0();
BasicControl.AxisState.Disabled             := MC_ReadStatus_0.Disabled;
BasicControl.AxisState.StandStill           := MC_ReadStatus_0.StandStill;
BasicControl.AxisState.Stopping             := MC_ReadStatus_0.Stopping;
BasicControl.AxisState.Homing               := MC_ReadStatus_0.Homing;
BasicControl.AxisState.DiscreteMotion       := MC_ReadStatus_0.DiscreteMotion;
BasicControl.AxisState.ContinuousMotion     := MC_ReadStatus_0.ContinuousMotion;
BasicControl.AxisState.SynchronizedMotion   := MC_ReadStatus_0.SynchronizedMotion;
BasicControl.AxisState.ErrorStop            := MC_ReadStatus_0.Errorstop;

(********************MC_BR_READDRIVESTATUS***********************)
MC_BR_ReadDriveStatus_0.Enable := NOT(MC_BR_ReadDriveStatus_0.Error);
MC_BR_ReadDriveStatus_0.Axis := Axis1Obj;
MC_BR_ReadDriveStatus_0.AdrDriveStatus := ADR(BasicControl.Status.DriveStatus);
MC_BR_ReadDriveStatus_0();

(******************** MC_READACTUALPOSITION *********************)
MC_ReadActualPosition_0.Enable := (NOT(MC_ReadActualPosition_0.Error));
MC_ReadActualPosition_0.Axis := Axis1Obj;
MC_ReadActualPosition_0();
IF(MC_ReadActualPosition_0.Valid = TRUE)THEN
    BasicControl.Status.ActPosition := MC_ReadActualPosition_0.Position;
END_IF

(******************** MC_READACTUALVELOCITY *********************)
MC_ReadActualVelocity_0.Enable := (NOT(MC_ReadActualVelocity_0.Error));
MC_ReadActualVelocity_0.Axis := Axis1Obj;
MC_ReadActualVelocity_0();
IF(MC_ReadActualVelocity_0.Valid = TRUE)THEN
    BasicControl.Status.ActVelocity := MC_ReadActualVelocity_0.Velocity;
END_IF

(************************ MC_READAXISERROR **********************)
MC_ReadAxisError_0.Enable := NOT(MC_ReadAxisError_0.Error);
MC_ReadAxisError_0.Axis := Axis1Obj;
MC_ReadAxisError_0.DataAddress := ADR(BasicControl.Status.ErrorText);
MC_ReadAxisError_0.DataLength := SIZEOF(BasicControl.Status.ErrorText);
MC_ReadAxisError_0.DataObjectName := 'acp10etxen';
MC_ReadAxisError_0();

(**************** CHECK FOR GENERAL AXIS ERROR ******************)
    IF ((MC_ReadAxisError_0.AxisErrorID <> 0) AND (MC_ReadAxisError_0.Valid = TRUE)) THEN
        AxisStep := STATE_ERROR_AXIS;
(***************** CHECK IF POWER SHOULD BE OFF *******************)
    ELSIF ((BasicControl.Command.Power = FALSE) AND (MC_ReadAxisError_0.Valid = TRUE)) THEN
        IF ((MC_ReadStatus_0.Errorstop = TRUE) AND (MC_ReadStatus_0.Valid = TRUE)) THEN
            AxisStep := STATE_ERROR_RESET;
        ELSE
            AxisStep := STATE_WAIT;
        END_IF
    END_IF

(* central monitoring OF stop command attains a shorter reaction TIME in CASE OF emergency stop *)
(******************CHECK FOR STOP COMMAND************************)
    IF (BasicControl.Command.Stop = TRUE) THEN
        IF ((AxisStep >= STATE_HOME) AND (AxisStep <= STATE_ERROR)) THEN
            (* reset all FB execute inputs we use *)
            MC_Home_0.Execute := 0;
            MC_Stop_0.Execute := 0;
            MC_MoveAbsolute_0.Execute := 0;
            MC_MoveAdditive_0.Execute := 0;
            MC_MoveVelocity_0.Execute := 0;
            MC_ReadAxisError_0.Acknowledge := 0;
            MC_Reset_0.Execute := 0;
            MC_Halt_0.Execute := 0;

            (* reset user commands *)
            BasicControl.Command.Halt := 0;
            BasicControl.Command.Home := 0;
            BasicControl.Command.MoveJogPos := 0;
            BasicControl.Command.MoveJogNeg := 0;
            BasicControl.Command.MoveVelocity := 0;
            BasicControl.Command.MoveAbsolute := 0;
            BasicControl.Command.MoveAdditive := 0;
            AxisStep := STATE_STOP;
        END_IF
    END_IF

CASE AxisStep OF

(******************** WAIT *************************)
    STATE_WAIT:  (* STATE: Wait *)
        IF (BasicControl.Command.Power = TRUE) THEN
            AxisStep := STATE_POWER_ON;
        ELSE
            MC_Power_0.Enable := FALSE;
        END_IF

        (* reset all FB execute inputs we use *)
        MC_Home_0.Execute := FALSE;
        MC_Stop_0.Execute := FALSE;
        MC_MoveAbsolute_0.Execute := FALSE;
        MC_MoveAdditive_0.Execute := FALSE;
        MC_MoveVelocity_0.Execute := FALSE;
        MC_Halt_0.Execute := FALSE;
        MC_ReadAxisError_0.Acknowledge := FALSE;
        MC_Reset_0.Execute := FALSE;

        (* reset user commands *)
        BasicControl.Command.Stop := FALSE;
        BasicControl.Command.Halt := FALSE;
        BasicControl.Command.Home := FALSE;
        BasicControl.Command.MoveJogPos := FALSE;
        BasicControl.Command.MoveJogNeg := FALSE;
        BasicControl.Command.MoveVelocity := FALSE;
        BasicControl.Command.MoveAbsolute := FALSE;
        BasicControl.Command.MoveAdditive := FALSE;

        BasicControl.Status.ErrorID := 0;

(******************** POWER ON **********************)
    STATE_POWER_ON:  (* STATE: Power on *)
        MC_Power_0.Enable := TRUE;
        IF (MC_Power_0.Status = TRUE) THEN
            AxisStep := STATE_READY;
        END_IF
        (* if a power error occured go to error state *)
        IF (MC_Power_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_Power_0.ErrorID;
            AxisStep := STATE_ERROR;
        END_IF

(******************** READY **********************)
    STATE_READY:  (* STATE: Waiting for commands *)
        IF (BasicControl.Command.Home = TRUE)THEN
            BasicControl.Command.Home := FALSE;
            AxisStep := STATE_HOME;

        ELSIF (BasicControl.Command.Stop = TRUE) THEN
            AxisStep := STATE_STOP;

        ELSIF (BasicControl.Command.MoveJogPos = TRUE) THEN
            AxisStep := STATE_JOG_POSITIVE;

        ELSIF (BasicControl.Command.MoveJogNeg = TRUE) THEN
            AxisStep := STATE_JOG_NEGATIVE;

        ELSIF (BasicControl.Command.MoveAbsolute = TRUE) THEN
            BasicControl.Command.MoveAbsolute := FALSE;
            AxisStep := STATE_MOVE_ABSOLUTE;

        ELSIF (BasicControl.Command.MoveAdditive = TRUE) THEN
            BasicControl.Command.MoveAdditive := FALSE;
            AxisStep := STATE_MOVE_ADDITIVE;

        ELSIF (BasicControl.Command.MoveVelocity = TRUE) THEN
            BasicControl.Command.MoveVelocity := FALSE;
            AxisStep := STATE_MOVE_VELOCITY;
            
        ELSIF (BasicControl.Command.Halt = TRUE) THEN
            BasicControl.Command.Halt := FALSE;
            AxisStep := STATE_HALT;                                    
        END_IF

(******************** HOME **********************)
    STATE_HOME:  (* STATE: start homing process *)
        MC_Home_0.Position := BasicControl.Parameter.HomePosition;
        MC_Home_0.HomingMode := BasicControl.Parameter.HomeMode;
        MC_Home_0.Execute := TRUE;
        IF (MC_Home_0.Done = TRUE) THEN
            MC_Home_0.Execute := FALSE;
            AxisStep := STATE_READY;
        END_IF
        (* if a homing error occured go to error state *)
        IF (MC_Home_0.Error = TRUE) THEN
            MC_Home_0.Execute := FALSE;
            BasicControl.Status.ErrorID := MC_Home_0.ErrorID;
            AxisStep := STATE_ERROR;
        END_IF
        
(***********************HALT_MOVEMENT***************************)
    STATE_HALT:   (* STATE: Halt movement *)
        MC_Halt_0.Deceleration := BasicControl.Parameter.Deceleration;
        MC_Halt_0.Execute := TRUE;
        IF (MC_Halt_0.Done = TRUE) THEN
            MC_Halt_0.Execute := FALSE;
            AxisStep := STATE_READY;        
        END_IF
        (* check if error occured *)
        IF (MC_Halt_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_Halt_0.ErrorID;
            MC_Halt_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF                                         

(*********************** STOP MOVEMENT *************************)
    STATE_STOP:  (* STATE: Stop movement *)
        MC_Stop_0.Deceleration := BasicControl.Parameter.Deceleration;
        MC_Stop_0.Execute := TRUE;
        (* if axis is stopped go to ready state *)
        IF ((MC_Stop_0.Done = TRUE) AND (BasicControl.Command.Stop = FALSE)) THEN
            MC_Stop_0.Execute := FALSE;
            AxisStep := STATE_READY;
        END_IF
        (* check if error occured *)
        IF (MC_Stop_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_Stop_0.ErrorID;
            MC_Stop_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** START JOG MOVEMENT POSITVE **********************)
     STATE_JOG_POSITIVE:  (* STATE: Start jog movement in positive direction *)
        MC_MoveVelocity_0.Velocity      := BasicControl.Parameter.JogVelocity;
        MC_MoveVelocity_0.Acceleration  := BasicControl.Parameter.Acceleration;
        MC_MoveVelocity_0.Deceleration  := BasicControl.Parameter.Deceleration;
        MC_MoveVelocity_0.Direction     := mcPOSITIVE_DIR;
        MC_MoveVelocity_0.Execute := TRUE;
        IF (BasicControl.Command.MoveJogPos = FALSE) THEN
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_HALT;
        END_IF
        (* check if error occured *)
        IF (MC_MoveVelocity_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_MoveVelocity_0.ErrorID;
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** START JOG MOVEMENT NEGATIVE **********************)
    STATE_JOG_NEGATIVE:  (* STATE: Start jog movement in negative direction *)
        MC_MoveVelocity_0.Velocity      := BasicControl.Parameter.JogVelocity;
        MC_MoveVelocity_0.Acceleration  := BasicControl.Parameter.Acceleration;
        MC_MoveVelocity_0.Deceleration  := BasicControl.Parameter.Deceleration;
        MC_MoveVelocity_0.Direction	    := mcNEGATIVE_DIR;
        MC_MoveVelocity_0.Execute := TRUE;
        IF (BasicControl.Command.MoveJogNeg = FALSE) THEN
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_HALT;
        END_IF
        (* check if error occured *)
        IF (MC_MoveVelocity_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_MoveVelocity_0.ErrorID;
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** START ABSOLUTE MOVEMENT **********************)
     STATE_MOVE_ABSOLUTE:  (* STATE: Start absolute movement *)
        MC_MoveAbsolute_0.Position      := BasicControl.Parameter.Position; 
        MC_MoveAbsolute_0.Velocity      := BasicControl.Parameter.Velocity;
        MC_MoveAbsolute_0.Acceleration  := BasicControl.Parameter.Acceleration;
        MC_MoveAbsolute_0.Deceleration  := BasicControl.Parameter.Deceleration;
        MC_MoveAbsolute_0.Direction     := BasicControl.Parameter.Direction;
        MC_MoveAbsolute_0.Execute := TRUE;
        (* check if commanded position is reached *)
        IF (BasicControl.Command.Halt) THEN
            BasicControl.Command.Halt := FALSE;
            MC_MoveAbsolute_0.Execute := FALSE;
            AxisStep := STATE_HALT;
        ELSIF (MC_MoveAbsolute_0.Done = TRUE) THEN
            MC_MoveAbsolute_0.Execute := FALSE;
            AxisStep := STATE_READY;
        END_IF
        (* check if error occured *)
        IF (MC_MoveAbsolute_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_MoveAbsolute_0.ErrorID;
            MC_MoveAbsolute_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** START ADDITIVE MOVEMENT **********************)
    STATE_MOVE_ADDITIVE:  (* STATE: Start additive movement *)
        MC_MoveAdditive_0.Distance      := BasicControl.Parameter.Distance;
        MC_MoveAdditive_0.Velocity      := BasicControl.Parameter.Velocity;
        MC_MoveAdditive_0.Acceleration  := BasicControl.Parameter.Acceleration;
        MC_MoveAdditive_0.Deceleration  := BasicControl.Parameter.Deceleration;
        MC_MoveAdditive_0.Execute := TRUE;
        (* check if commanded distance is reached *)
        IF (BasicControl.Command.Halt) THEN
            BasicControl.Command.Halt := FALSE;
            MC_MoveAdditive_0.Execute := FALSE;
            AxisStep := STATE_HALT;
        ELSIF (MC_MoveAdditive_0.Done = TRUE) THEN
            MC_MoveAdditive_0.Execute := FALSE;
            AxisStep := STATE_READY;
        END_IF
        (* check if error occured *)
        IF (MC_MoveAdditive_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_MoveAdditive_0.ErrorID;
            MC_MoveAdditive_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** START VELOCITY MOVEMENT **********************)
    STATE_MOVE_VELOCITY:  (* STATE: Start velocity movement *)
        MC_MoveVelocity_0.Velocity      := BasicControl.Parameter.Velocity;
        MC_MoveVelocity_0.Acceleration  := BasicControl.Parameter.Acceleration;
        MC_MoveVelocity_0.Deceleration  := BasicControl.Parameter.Deceleration;
        MC_MoveVelocity_0.Direction     := BasicControl.Parameter.Direction;
        MC_MoveVelocity_0.Execute := TRUE;
        (* check if commanded velocity is reached *)
        IF (BasicControl.Command.Halt) THEN
            BasicControl.Command.Halt := FALSE;
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_HALT;
        ELSIF (MC_MoveVelocity_0.InVelocity = TRUE) THEN
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_READY;
        END_IF
        (* check if error occured *)
        IF (MC_MoveVelocity_0.Error = TRUE) THEN
            BasicControl.Status.ErrorID := MC_MoveVelocity_0.ErrorID;
            MC_MoveVelocity_0.Execute := FALSE;
            AxisStep := STATE_ERROR;
        END_IF

(******************** FB-ERROR OCCURED *************************)
    STATE_ERROR:  (* STATE: Error *)
        (* check if FB indicates an axis error *)
        IF (MC_ReadAxisError_0.AxisErrorCount<>0) THEN
            AxisStep := STATE_ERROR_AXIS;
        ELSE
            IF (BasicControl.Command.ErrorAcknowledge = TRUE) THEN
                BasicControl.Command.ErrorAcknowledge := FALSE;
                BasicControl.Status.ErrorID := 0;
                (* reset axis if it is in axis state ErrorStop *)
                IF ((MC_ReadStatus_0.Errorstop = TRUE) AND (MC_ReadStatus_0.Valid = TRUE)) THEN
                    AxisStep := STATE_ERROR_RESET;
                ELSE
                    AxisStep := STATE_WAIT;
                END_IF
            END_IF
        END_IF

(******************** AXIS-ERROR OCCURED *************************)
    STATE_ERROR_AXIS:  (* STATE: Axis Error *)
        IF (MC_ReadAxisError_0.Valid = TRUE) THEN
            IF (MC_ReadAxisError_0.AxisErrorID <> 0) THEN
                BasicControl.Status.ErrorID := MC_ReadAxisError_0.AxisErrorID;
            END_IF
            MC_ReadAxisError_0.Acknowledge := FALSE;
            IF (BasicControl.Command.ErrorAcknowledge = TRUE) THEN
                BasicControl.Command.ErrorAcknowledge := FALSE;
                (* acknowledge axis error *)
                IF (MC_ReadAxisError_0.AxisErrorID <> 0) THEN
                    MC_ReadAxisError_0.Acknowledge := TRUE;
                END_IF
            END_IF
            IF (MC_ReadAxisError_0.AxisErrorCount = 0) THEN
                (* reset axis if it is in axis state ErrorStop *)
                BasicControl.Status.ErrorID := 0;
                IF ((MC_ReadStatus_0.Errorstop = TRUE) AND (MC_ReadStatus_0.Valid = TRUE)) THEN
                    AxisStep := STATE_ERROR_RESET;
                ELSE
                    AxisStep := STATE_WAIT;
                END_IF
            END_IF
        END_IF

(******************** RESET DONE *************************)
    STATE_ERROR_RESET:  (* STATE: Wait for reset done *)
        MC_Reset_0.Execute := TRUE;
        (* reset MC_Power.Enable if this FB is in Error*)
        IF (MC_Power_0.Error = TRUE) THEN
            MC_Power_0.Enable := FALSE;
        END_IF
        IF(MC_Reset_0.Done = TRUE)THEN
            MC_Reset_0.Execute := FALSE;
            AxisStep := STATE_WAIT;
        ELSIF(MC_Reset_0.Error = TRUE) THEN
            MC_Reset_0.Execute := FALSE;
            AxisStep := STATE_ERROR;                    
        END_IF
(******************** SEQUENCE END *************************)
END_CASE

(***************************************************************
        Function Block Calls
***************************************************************)

(************************** MC_POWER ****************************)
MC_Power_0.Axis := Axis1Obj;  (* pointer to axis *)
MC_Power_0();

(************************** MC_HOME *****************************)
MC_Home_0.Axis := Axis1Obj;
MC_Home_0();

(********************** MC_MOVEABSOLUTE *************************)
MC_MoveAbsolute_0.Axis := Axis1Obj;
MC_MoveAbsolute_0();

(********************** MC_MOVEADDITIVE *************************)
MC_MoveAdditive_0.Axis := Axis1Obj;
MC_MoveAdditive_0();

(********************** MC_MOVEVELOCITY *************************)
MC_MoveVelocity_0.Axis := Axis1Obj;
MC_MoveVelocity_0();

(************************** MC_STOP *****************************)
MC_Stop_0.Axis := Axis1Obj;
MC_Stop_0();

(***************************MC_HALT******************************)
MC_Halt_0.Axis := Axis1Obj;
MC_Halt_0();

(************************** MC_RESET ****************************)
MC_Reset_0.Axis := Axis1Obj;
MC_Reset_0();

END_PROGRAM

