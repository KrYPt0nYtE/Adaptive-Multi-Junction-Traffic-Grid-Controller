### Clock & Frequency Domain:

- [x] The entire system operates under a single synchronous clock domain at a nominal frequency of 100 MHz (10 ns period).  
- [x] All inputs (traffic_density, ped_request, emergency_override) are assumed to be synchronized to the rising edge of clk before driving core FSM logic.  

### Reset Semantics:
- [x] Reset is active-high, synchronous, and asserted for at least 2 full clock cycles during power-on initialization to guarantee deterministic state entry (State 0).  

### Pedestrian Interlock Constraints:
- [x] Pedestrians are never granted immediate instantaneous access while vehicular traffic is in a green or yellow phase. The FSM must always transition through yellow caution and all-red clearance buffers before asserting ped_allow.  

- [x] A single pedestrian crossing interval is bounded by a fixed safety timer duration.

### Emergency Priority & Clearance:

- [x] emergency_override has absolute priority over normal traffic timing and pedestrian grants.  

- [x] The transition to All-Red occurs within ≤1 clock cycle.  

- [x] Upon emergency deassertion, resuming via an intermediate All-Red state (ALL_RED1 or ALL_RED2) is required to safely clear any residual intersection traffic before enabling vehicular green lights.  

### Corridor Geometry & Green-Wave Delay:

- [x] The GREEN_WAVE_OFFSET = 5 assumes uniform vehicle travel velocity between Junction A and Junction B along the North-South arterial corridor.  

- [x] Reverse synchronization (South-to-North) is outside the operational scope of the dual-junction model.
