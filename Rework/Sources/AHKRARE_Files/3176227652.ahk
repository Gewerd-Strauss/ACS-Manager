SetTimerEx(period, func, params*) {                                                                            	;-- Similar to SetTimer, but calls a function, optionally with one or more parameters
    static s_timers, s_next_tick, s_timer, s_index, s_max_index

    if !s_timers  ; Init timers array and ensure script is #persistent.
        s_timers := Object(), n:="OnMessage",%n%(0)

    if (func = "!") ; Internal use.
    {
        ; This is a workaround for the timer-tick sub not being able to see itself
        ; in v2 (since it is local to the function, which is not running).
        SetTimer timer-tick, % period
        return
    }

    if !IsFunc(func)
        return

    ; Create a timer.
    timer           := {base: {stop: "Timer_Stop"}}
    timer.run_once  := period < 0
    timer.period    := period := Abs(period)
    timer.next_run  := next_run := A_TickCount + period
    timer.func      := func
    timer.params    := params

    ; If the timer is not set to run before next_run, set it:
    if (!s_next_tick ||