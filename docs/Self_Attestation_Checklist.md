## Student Self-Attestation & Delivery Compliance Checklist

### 1. Repository Organization & Structure
- [x] Dedicated `/rtl` directory containing synthesizable source files (`amtgc_top.v`, sub-modules).
- [x] Dedicated `/tb` directory containing the self-checking testbench (`tb_amtgc_final_verification.v`).
- [x] Dedicated `/sim` directory with subfolders for `/scripts`, `/logs`, and `/waveforms`.
- [x] Dedicated `/docs` directory containing architecture diagrams and the final technical report.
- [x] Top-level `README.md` includes system overview, prerequisite tools, and exact CLI reproduction steps.

### 2. Design & Code Integrity
- [x] 100% compliant with standard Verilog (IEEE 1364-2001); no SystemVerilog-exclusive syntax used.
- [x] RTL is strictly synchronous, single clock domain, with parameterized timers and offsets.
- [x] Delivered RTL is identical to the verified version from Task 5 (no untested modifications).

### 3. Functional Verification & Safety Compliance
- [x] All 15 automated test cases (TC01 to TC15) pass with zero errors.
- [x] Continuous background assertions actively monitor for:
  - Conflicting green signals (Zero vehicular hazards).
  - Pedestrian safety interlocks (Zero crossing grants during moving traffic).
  - Emergency All-Red enforcement across all 7 operational states.
- [x] Constrained-random stress testing executed for 120+ cycles without deadlocks.

### 4. Verification Evidence & Artifacts
- [x] Full simulation transcript archived at `sim/logs/task5_full_verification.log`.
- [x] Waveform screenshots annotated and archived in `sim/waveforms/`.
- [x] Demonstration video produced covering block diagram, live simulation, and scoreboard results.

**Attestation:**  
I hereby attest that the attached design, testbenches, and documentation represent my authentic work, adhere strictly to the course specification, and can be fully reproduced by any reviewer following the README instructions.
