PROGRAM _INIT

(* get axis object *)
Axis1Obj := ADR(gAxis01);

AxisStep := STATE_WAIT; (* start step *)

BasicControl.Parameter.Velocity             := 1000;  (*velocity for movement*)
BasicControl.Parameter.Acceleration         := 5000;  (*acceleration for movement*)
BasicControl.Parameter.Deceleration         := 5000;  (*deceleration for movement*)
BasicControl.Parameter.JogVelocity          := 400;   (*velocity for jogging *)
END_PROGRAM

