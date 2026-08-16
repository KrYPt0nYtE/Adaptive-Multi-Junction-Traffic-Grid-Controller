# Adaptive Multi-Junction Traffic Grid Controller (AMTGC)

Synthesizable System-on-Chip Verilog implementation of an Adaptive Multi-Junction Traffic Grid Controller featuring traffic-density adaptivity, green-wave offset coordination, Round-Robin pedestrian arbitration, and fail-safe emergency override capabilities.

---

## Key Architectural Features

- **Traffic-Adaptive Dynamic Timing**: Proportional green-phase scaling clamped between parameterized `MIN_GREEN` and `MAX_GREEN` safety bounds.
- **Glitch-Immune Latching**: Intermediate state sampling preventing mid-cycle truncation from sensor fluctuation.
- **Green-Wave Synchronization**: Parameterized phase offset coordination between Junction A and Junction B.
- **Fair Pedestrian Arbitration**: Round-Robin grant distribution ensuring starvation-free service across 100+ transactions.
- **Asynchronous Emergency Override**: 1-cycle fail-safe All-Red transition with safe buffer recovery.
- **Modular Hardware Architecture**: Completely untouched, reusable `generic_timer` counting core.

---

## Directory Organization

- `/rtl`: Synthesizable Verilog source files (`generic_timer.v`, `junction_controller.v`, `ped_arbiter.v`, `amtgc_top.v`).
- `/tb`: Unit, feature-specific, and unified self-checking top-level testbenches.
- `/docs`: Technical report, architecture diagrams, bug logs, and self-attestation checklist.
- `/sim`: ModelSim transcript logs and simulation waveform captures (TC01–TC15).
- `/video`: Demonstration walkthrough video.

---

## Simulation & Reproduction Guide

### Prerequisites
- ModelSim / QuestaSim (v10.5+ or compatible Verilog-2001 simulator)

### Execution Commands

```bash
# 1. Compile RTL and Verification Suites
vlog rtl/generic_timer.v rtl/junction_controller.v rtl/ped_arbiter.v rtl/amtgc_top.v tb/*.v

# 2. Run Baseline Integration Simulation (Task 3)
vsim work.tb_amtgc_top -do "run -all"

# 3. Run Adaptive Timing Sweep (Task 4)
vsim work.tb_amtgc_adaptive -do "run -all"

# 4. Run Full System Automated Verification (Task 5 - TC01 to TC15)
vsim -c work.tb_amtgc_final_verification -do "run -all; quit"
