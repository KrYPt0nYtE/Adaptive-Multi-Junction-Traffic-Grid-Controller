# Bug Fix & Verification Log

This document records the bugs identified during verification of the
Traffic Junction Controller testbench, along with their root causes,
impacts, applied resolutions, and verification status.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Bug ID       Test Scenario Root Cause                                           Impact                          Resolution Applied                                   Verification
                                                                                                                                                                       Status
  ------------ ------------- ---------------------------------------------------- ------------------------------- ---------------------------------------------------- --------------
  **BUG-01**   TC06 / TC07   Non-clock-aligned `#10` stimulus pulse deasserted    Testbench deadlock:             Synchronized assertion to `@(posedge clk)`,          **CLOSED /
               (Pedestrian   before the active green countdown timer completed.   `wait(current_state == 4'd6)`   maintained the request until it was granted, and     VERIFIED**
               Request)                                                           hung indefinitely at            added a bounded **200-cycle** loop timeout.          
                                                                                  approximately **4.85 ms**.                                                           

  **BUG-02**   Check 3       Boolean assertion logic used                         Inverted logical mask allowed   Replaced `||` with a strict conjunction:             **CLOSED /
               (Emergency    `!(NS_red_A || EW_red_A || NS_red_B || EW_red_B)`.   hazardous single-junction green `!(NS_red_A && EW_red_A && NS_red_B && EW_red_B)`.   VERIFIED**
               Monitor)                                                           lights during active emergency                                                       
                                                                                  overrides without failing the                                                        
                                                                                  check.                                                                               

  **BUG-03**   TC12          State inspection sampled on the immediate clock edge Race condition: sampled stale   Added **1 clock cycle** of recovery latency plus a   **CLOSED /
               (Emergency    where `emergency_override` dropped to `0`.           register states prior to        `#1` delta delay before asserting state membership   VERIFIED**
               Recovery)                                                          non-blocking assignment (`<=`)  in `{State 2, State 5}`.                             
                                                                                  resolution.                                                                          

  **BUG-04**   TC09          Stimulus loop used a self-referencing single-bit     Alternating 1-bit toggle was    Updated the modulo reference to the loop induction   **CLOSED /
               (Starvation   modulo: `ped_request_A <= (ped_request_A % 2 == 0)`. generated instead of testing    variable: `(ped_iteration % 2 == 0)`.                VERIFIED**
               Test)                                                              true coprime sequence                                                                
                                                                                  intervals.                                                                           

  **BUG-05**   TC05 (Max     Typo in stimulus assignment set                      Junction B clamp logic remained Corrected the assignment to                          **CLOSED /
               Clamp Test)   `traffic_density_A = 3'd7` instead of Junction B.    unexercised under peak-load     `traffic_density_B = 3'd7`.                          VERIFIED**
                                                                                  conditions.                                                                          
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Verification Summary

All five identified bugs were resolved and subsequently verified through
the corresponding test scenarios and checks.

-   **Total bugs identified:** 5
-   **Bugs resolved:** 5
-   **Bugs verified:** 5
-   **Open bugs:** 0
-   **Overall status:** **CLOSED / VERIFIED**

## Key Verification Improvements

The fixes also improved the robustness of the verification environment
by:

1.  Synchronizing stimulus with the design clock where required.
2.  Preventing testbench deadlocks through bounded timeout mechanisms.
3.  Correcting emergency-state safety assertions.
4.  Accounting for non-blocking assignment scheduling and simulation
    delta cycles.
5.  Ensuring starvation tests exercise the intended request pattern.
6.  Correctly exercising maximum traffic-density clamp behavior.
