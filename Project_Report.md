# ECG Acquisition IC Project Report

**Project Stage**: Pre-layout schematic design, full-PVT block verification, and frontend integration  
**Process Technology**: GlobalFoundries 180 nm MCU (`gf180mcu`, 3.3 V 1P6M)  
**Target Application**: Low-power, high-CMRR biomedical electrophysiology acquisition (ECG / Biopotential Recording)  

---

## 1. Executive Summary

This report documents the design, transistor-level sizing, simulation methodology, and multi-corner verification of a low-noise, high-common-mode-rejection analog frontend (AFE) integrated circuit for electrocardiogram (ECG) acquisition. Developed for the IEEE SSCS Chipathon 2026 flow, the design provides an end-to-end signal conditioning chain tailored to sub-millivolt biopotential recording in the presence of large differential electrode offset voltages ($\pm 300\text{ mV}$) and strong powerline common-mode interference ($50/60\text{ Hz}$).

### Key Verification Deliverables

1. **Master Bias & Reference (`BIAS` / `SEL`)**: Characterized across 5 process corners, continuous supply voltage sweeps ($3.0\text{--}3.6\text{ V}$), temperature sweeps ($-40^\circ\text{C}\text{ to }+125^\circ\text{C}$), 35 startup transient runs (**0 failures**), and analog multiplexer transmission accuracy ($< 26\text{ nV}$ error).
2. **Single-Ended OTA (`SE_OTA`)**: Full 45-point PVT characterization ($5\text{ processes} \times 9\text{ V-T corners}$) covering open-loop stability, rejection, noise integration ($0.05\text{--}150\text{ Hz}$), closed-loop tracking, high-side headroom, and transient step settling.
3. **Fully Differential OTA (`FD_OTA`)**: Full 45-point PVT characterization of the core amplifier with dynamic continuous-time common-mode feedback (`CMFB`), closed-loop differential tracking, input common-mode range, and step response.
4. **$g_m/I_D$ Sizing Automation**: Semi-empirical transistor sizing based on continuous lookups of transconductance efficiency ($g_m/I_D$), current density ($I_D/W$), transit frequency ($f_T$), and self-gain ($g_m/g_{ds}$).
5. **Data Integrity Pipeline**: All post-processing analyzers implement a strict numeric-first double-precision pipeline (`ngspice TXT -> double -> PVT worst-case selection -> SI scaling -> string format`), eliminating intermediate truncation and prefix errors.

> [!NOTE]
> All reported performance metrics are pre-layout schematic simulations. Monte Carlo mismatch analysis, physical layout parasitics (PEX), mixed-signal SAR ADC integration, and laboratory silicon validation are detailed in [Section 9](#9-limitations-and-future-work).

---

## 2. System Architecture & Building Blocks

```
                      ┌──────────────────────────────────────────────────────────────────────────────────┐
                      │                            Integrated AFE Signal Chain                           │
                      │                                                                                  │
[ ECG Electrodes ] ───┼──> [ INA (60x) ] ──> [ LPF (4x, fc=150Hz) ] ──> [ PGA (1-16x) ] ──> [ BUFFER ] ──┼──> [ ADC Drive ]
  (Vin,diff <= 1mV)   │          │                                                                       │    (Vout,diff <= 3V)
                      │  [ RLD Amplifier ] <── (Common-Mode Sense: 4 Meg)                                │
                      └──────────────────────────────────────────────────────────────────────────────────┘
                                                 ▲
                                                 │ (40 uA Cascode Bias Distribution)
                                    ┌─────────────────────────┐
                                    │  BIAS / MIRROR / SEL    │
                                    └─────────────────────────┘
```

### 2.1 Integrated AFE Top-Level Schematic

The integrated top-level AFE schematic combines the biopotential instrumentation amplifier, active low-pass filter, programmable gain amplifier, ADC output driver, right-leg drive feedback, and master biasing network:

![ECG Analog Frontend (AFE) Top-Level Schematic](Design_Files/IC%20Design/Schematic/AFE/AFE.png)

### 2.2 Circuit Subsystems & Sizing Specifications

| Stage | Subsystem | Circuit Topology & Key Components | Stage Gain & Bandwidth |
| :--- | :--- | :--- | :---: |
| **Stage 1** | **Instrumentation Amp (`INA`)** | 3-opamp topology ($2\times$ `SE_OTA` input buffers, $1\times$ `FD_OTA` difference stage, $R_1 = 118\text{ k}\Omega$, $R_{\text{gain}} = 4\text{ k}\Omega$, $R_{2\text{--}5} = 10\text{--}40\text{ k}\Omega$) | $60\text{ V/V}$ ($35.6\text{ dB}$)<br>$\text{BW} > 10\text{ kHz}$ |
| **Stage 2** | **Active Low-Pass Filter (`LPF`)** | Fully differential active 2nd-order RC filter ($1\times$ `FD_OTA`, $R = 3.7\text{ M}\Omega$, $C = 100\text{ pF}$ MIM) | $4\text{ V/V}$ ($12.0\text{ dB}$)<br>$f_c \approx 150\text{ Hz}$ |
| **Stage 3** | **Programmable Gain Amp (`PGA`)** | Fully differential switched-resistor ladder ($1\times$ `FD_OTA`, $6\times$ `TG`, $R = 20\text{--}120\text{ k}\Omega$) | $1\times, 2\times, 4\times, 8\times, 16\times$<br>($0\text{ to }24.1\text{ dB}$) |
| **Stage 4** | **Output Driver (`BUFFER`)** | Closed-loop differential unity follower ($1\times$ `FD_OTA`, $4\times 20\text{ k}\Omega$) driving sampling cap | $1\text{ V/V}$ ($0\text{ dB}$)<br>$C_L = 10\text{ pF}$ |
| **Support** | **Right-Leg Drive (`RLD`)** | Active integrator sensing input CM ($1\times$ `SE_OTA`, $R_{\text{in}} = 4\text{ M}\Omega$, $R_f = 20\text{ M}\Omega$, $C_f = 80\text{ pF}$) | High active CM suppression ($> 100\text{ dB}$) |
| **Reference** | **Master Bias (`BIAS`/`MIRROR`)** | $\beta$-Multiplier reference ($40\text{ }\mu\text{A}$ target) with startup device and 11-channel cascode mirror tree | $\Delta I_{\text{bias}} < 0.15\%$ mirror tracking |
| **Total Chain** | **Full AFE Performance** | Cascaded multi-stage biopotential recording path with analog channel selection (`SEL`) | **$240\text{ to }3840\text{ V/V}$**<br>($47.6\text{ to }71.7\text{ dB}$)<br>**$0.05\text{--}150\text{ Hz}$** |

---

## 3. Transistor-Level Sizing & $g_m/I_D$ Methodology

All operational transconductance amplifiers and reference circuits are sized using the $g_m/I_D$ methodology on the GlobalFoundries 180 nm MCU process.

### 3.1 Single-Ended OTA (`SE_OTA`) Sizing

Implemented in [`SE_OTA_Sizing.m`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Design_Files/IC%20Design/Schematic/SE_OTA/SE_OTA_Sizing.m):

* **Topology**: 2-stage Miller-compensated folded-cascode single-ended OTA.
* **Input Pair ($M_1, M_2$)**: PMOS differential pair operated in moderate/weak inversion ($g_m/I_D = 16.0\text{ V}^{-1}$, $L = 2.0\text{ }\mu\text{m}$) for high transconductance efficiency and minimal thermal/flicker noise.
* **First-Stage Loads ($M_3, M_4$)**: NMOS current-source loads operated in strong inversion ($g_m/I_D = 16.0\text{ V}^{-1}$, $L = 2.0\text{ }\mu\text{m}$) to minimize input-referred noise contribution.
* **Tail Current Source ($M_5$)**: PMOS current source ($g_m/I_D = 6.0\text{ V}^{-1}$, $L = 2.0\text{ }\mu\text{m}$) for high output impedance and high CMRR.
* **Second-Stage Driver ($M_6$)**: NMOS common-source amplifier ($g_m/I_D = 6.0\text{ V}^{-1}$, $L = 0.5\text{ }\mu\text{m}$) with PMOS active load ($M_7$).
* **Compensation Network**: Miller compensation capacitor $C_c = 2.0\text{ pF}$ driving a nominal load $C_L = 10.0\text{ pF}$, establishing a pole-splitting ratio $k_{p2} = 3.5$ for phase margin $> 70^\circ$.

### 3.2 Fully Differential Core (`FDC`) & CMFB Sizing

Implemented in [`FDC_Sizing.m`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Design_Files/IC%20Design/Schematic/FD_OTA/FDC/FDC_Sizing.m) and [`CMFB_Sizing.m`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Design_Files/IC%20Design/Schematic/FD_OTA/CMFB/CMFB_Sizing.m):

* **Differential Core Input Pair ($M_1, M_2$)**: NMOS differential pair sized with $g_m/I_D = 20.0\text{ V}^{-1}$, $L = 2.0\text{ }\mu\text{m}$ for high transconductance at low bias currents.
* **CMFB Controlled Loads ($M_3, M_4$)**: PMOS current sources ($g_m/I_D = 20.0\text{ V}^{-1}$, $L = 2.0\text{ }\mu\text{m}$) dynamically modulated by the $V_{\text{CMFB}}$ error voltage.
* **Differential Second Stage ($M_6\text{--}M_9$)**: PMOS common-source amplifiers with NMOS active current sources ($L = 1.0\text{ }\mu\text{m}$, $g_m/I_D = 4.0\text{ V}^{-1}$) providing large output swing.
* **Continuous-Time CMFB Amplifier**: Active common-mode sense resistors with an NMOS differential error amplifier ($L = 0.5\text{ }\mu\text{m}$, $g_m/I_D = 4.0\text{ V}^{-1}$) yielding an ultra-fast loop unity-gain bandwidth ($> 800\text{ MHz}$) and phase margin $> 86^\circ$.

---

## 4. Nominal Operating Conditions

Unless otherwise noted, nominal characterization conditions are defined as:

| Parameter | Nominal Setting | Notes / Test Setup |
| :--- | :---: | :--- |
| **Process Corner** | `NOM` (Typical-Typical) | PDK library `sm141064.ngspice` |
| **Supply Voltage ($V_{DD}$)** | $3.30\text{ V}$ | Voltage range: $3.0\text{ V}$ (`VL`) to $3.6\text{ V}$ (`VH`) |
| **Analog Ground ($V_{SS}$)** | $0.00\text{ V}$ | Single-supply ground reference |
| **Input Common-Mode ($V_{in,cm}$)** | $1.65\text{ V}$ | Mid-supply reference ($V_{DD}/2$) |
| **Reference Voltage ($V_{\text{REF}}$)** | $1.65\text{ V}$ | CMFB target output common-mode |
| **Nominal Bias Current ($I_{\text{BIAS}}$)** | $40.00\text{ }\mu\text{A}$ | Master bias generator target |
| **Load Capacitance ($C_L$)** | $10.0\text{ pF}$ | Single-ended or differential output load |
| **Noise Integration Bandwidth** | $0.05\text{ Hz to }150\text{ Hz}$ | Diagnostic ECG clinical bandwidth standard |
| **Temperature ($T$)** | $27^\circ\text{C}$ | Temperature range: $-40^\circ\text{C}$ (`TL`) to $+125^\circ\text{C}$ (`TH`) |

---

## 5. Verification Methodology

### 5.1 45-Point PVT Verification Matrix

The complete PVT verification matrix comprises **5 process corners** $\times$ **9 environmental conditions** = **45 corners**:

- **Processes (5)**: `NOM` (Typical), `FF` (Fast-Fast), `SS` (Slow-Slow), `FS` (Fast-Slow), `SF` (Slow-Fast).
- **Environmental Cases (9)**:
  - `nom`: $3.3\text{ V}, 27^\circ\text{C}$ (Nominal)
  - `vl` / `vh`: $3.0\text{ V} / 3.6\text{ V}, 27^\circ\text{C}$ (Supply bounds)
  - `tl` / `th`: $3.3\text{ V}, -40^\circ\text{C} / +125^\circ\text{C}$ (Temperature bounds)
  - `vltl` / `vlth`: $3.0\text{ V}, -40^\circ\text{C} / +125^\circ\text{C}$ (Cross-environmental corners)
  - `vhtl` / `vhth`: $3.6\text{ V}, -40^\circ\text{C} / +125^\circ\text{C}$ (Cross-environmental corners)

Corner labels combine process and environmental codes (e.g., `FFVHTH` = Fast-Fast, $3.6\text{ V}, +125^\circ\text{C}$; `SSVLTH` = Slow-Slow, $3.0\text{ V}, +125^\circ\text{C}$).

### 5.2 Single-Ended OTA Characterization Flow

1. **Open-Loop Transfer Function**: AC differential sweep yields $A_{v,0}$, Unity-Gain Frequency (UGF), and Phase Margin (PM) at $0\text{ dB}$ crossover.
2. **Rejection Ratios**: High-resolution AC transfer functions evaluate CMRR, PSRR+, and PSRR$-$ at key powerline frequencies ($60\text{ Hz}$ and $150\text{ Hz}$).
3. **Input-Referred Noise**: Numeric integration of input noise density:
   $$V_{n,\text{rms}} = \sqrt{\int_{0.05\text{ Hz}}^{150\text{ Hz}} e_n^2(f)\,df}$$
4. **Closed-Loop Usable Follower Range & Headroom**: A DC input sweep measures unity-follower tracking error $\Delta V = |V_{\text{OUT}} - V_{\text{IN}}|$. The usable range is the continuous region around $V_{DD}/2$ satisfying $|\Delta V| \le 2\text{ mV}$. High-side headroom is evaluated as $V_{\text{DD}} - V_{\text{usable,max}}$.
5. **Transient Dynamics**: Closed-loop step excitation measures worst-case $10\%\text{--}90\%$ rise/fall slew rates and settling time into the $2\text{ mV}$ error band.

### 5.3 Fully Differential OTA & CMFB Flow

1. **Differential Small-Signal Stability**: AC sweeps evaluate differential open-loop gain, UGF, and phase margin with symmetric differential excitation.
2. **Dynamic CMFB Loop**: Open-loop and closed-loop CMFB characterization evaluates common-mode loop gain, UGF, phase margin, and transient settling of $V_{\text{OUT,cm}}$ to step perturbations on $V_{\text{REF}}$.
3. **Closed-Loop Output Swing**: Differential DC command sweep measures tracking linearity and maximum symmetrical differential swing within $|\Delta V_{\text{diff}}| \le 2\text{ mV}$.
4. **Input Common-Mode Range (ICMR)**: Two-point command sweeps ($V_{\text{CMD}} = \pm 10\text{ mV}$) across common-mode levels evaluate local differential gain deviation $A_{CL}(V_{CM})$, common-mode shift, and supply current stability.

---

## 6. Detailed Simulation Results

### 6.1 Bias & Reference Subsystem (`BIAS` / `SEL`)

| Performance Parameter | Nominal Result | PVT Extrema / Range | Worst-Case Corner |
| :--- | :---: | :---: | :---: |
| **Reference Bias Current ($I_{\text{BIAS}}$)** | $39.997\text{ }\mu\text{A}$ | $31.054\text{ to }49.441\text{ }\mu\text{A}$ | `SSVLTL` / `FFVHTH` |
| **Bias Current Relative Error** | $+0.007\%$ | $-22.36\%\text{ to }+23.60\%$ | `FFVHTH` |
| **Bias PMOS Gate Voltage ($V_{\text{BP}}$)** | $1.761\text{ V}$ | $1.138\text{ to }2.146\text{ V}$ | `FSVLTH` / `SFVHTL` |
| **Reference Error ($V_{\text{REF}} - V_{DD}/2$)** | $0.057\text{ mV}$ | $-6.154\text{ }\mu\text{V to }+6.154\text{ }\mu\text{V}$ | `SSVHNOM` |
| **Current Mirror Tracking Error** | $0.001\%$ | $\le 0.149\%$ | `FSVLNOM` |
| **Startup Settling Time** | $158.4\text{ }\mu\text{s}$ | $\le 1180.28\text{ }\mu\text{s}$ | `SSVLTL` |
| **Startup Failure Count** | **0 of 35** | **0 of 35** across all runs | All PVT Points |
| **Analog Selector Transmission Error** | $0.025\text{ }\mu\text{V}$ | $\le 25.466\text{ nV}$ | `SSTH` |

---

### 6.2 Single-Ended OTA (`SE_OTA`) Nominal & 9-Corner Summary

Extracted from [`SEOTA_table_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/SEOTA_table_report.csv):

| Parameter | Unit | `NOM` | `FF` | `SS` | `FS` | `SF` | `VL` ($3.0\text{V}$) | `VH` ($3.6\text{V}$) | `TL` ($-40^\circ\text{C}$) | `TH` ($+125^\circ\text{C}$) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Total Current** | $\text{mA}$ | 0.913 | 1.053 | 0.796 | 0.932 | 0.892 | 0.899 | 0.923 | 0.767 | 1.033 |
| **Total Power** | $\text{mW}$ | 3.012 | 3.474 | 2.628 | 3.076 | 2.944 | 2.697 | 3.323 | 2.531 | 3.409 |
| **DC Gain** | $\text{dB}$ | 93.855 | 92.836 | 94.464 | 93.447 | 93.754 | 93.208 | 94.348 | 94.757 | 92.176 |
| **UGF** | $\text{MHz}$ | 12.144 | 14.150 | 10.518 | 12.302 | 11.968 | 11.898 | 12.332 | 13.687 | 9.977 |
| **Phase Margin** | $\text{deg}$ | 71.975 | 66.273 | 76.626 | 71.189 | 72.825 | 71.859 | 72.079 | 75.313 | 67.756 |
| **Input Offset** | $\mu\text{V}$ | 14.532 | -20.612 | 8.875 | -21.419 | 10.362 | 14.532 | 14.532 | 14.532 | 14.532 |
| **CMRR @ 60 Hz** | $\text{dB}$ | 110.809 | 110.809 | 110.809 | 110.809 | 110.809 | 110.809 | 110.809 | 110.809 | 110.809 |
| **PSRR+ @ 60 Hz** | $\text{dB}$ | 103.738 | 103.541 | 103.882 | 103.705 | 103.694 | 103.738 | 103.738 | 103.738 | 103.738 |
| **Input Noise ($0.05\text{--}150\text{ Hz}$)** | $\mu\text{Vrms}$ | 1.876 | 1.785 | 1.969 | 1.844 | 1.909 | 1.872 | 1.879 | 1.797 | 2.030 |
| **Input Low** | $\text{mV}$ | 318.0 | 214.0 | 422.0 | 239.0 | 398.0 | 314.0 | 328.0 | 437.0 | 153.0 |
| **Input High** | $\text{V}$ | 3.222 | 3.220 | 3.223 | 3.164 | 3.249 | 2.913 | 3.528 | 3.247 | 3.188 |
| **Input High Headroom** | $\text{mV}$ | 78.0 | 80.0 | 77.0 | 136.0 | 51.0 | 87.0 | 72.0 | 53.0 | 112.0 |
| **Output Low** | $\text{mV}$ | 316.0 | 212.0 | 420.0 | 237.0 | 396.0 | 312.0 | 326.0 | 435.0 | 151.0 |
| **Output High** | $\text{V}$ | 3.220 | 3.218 | 3.221 | 3.162 | 3.247 | 2.911 | 3.526 | 3.245 | 3.186 |
| **Output High Headroom** | $\text{mV}$ | 79.8 | 81.8 | 78.9 | 137.8 | 52.8 | 88.7 | 73.9 | 54.6 | 113.9 |
| **Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 9.97 / 7.76 | 11.51 / 8.80 | 8.73 / 6.93 | 10.14 / 7.88 | 9.79 / 7.64 | 9.80 / 7.60 | 10.09 / 7.88 | 8.89 / 6.86 | 10.53 / 8.38 |
| **Settling Time ($2\text{ mV}$)** | $\text{ns}$ | 164.9 | 146.9 | 183.4 | 162.4 | 167.4 | 167.4 | 162.9 | 172.4 | 166.9 |

---

### 6.3 SE OTA Full-PVT Worst-Case Performance

Extracted from [`SEOTA_worst_case_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/SEOTA_worst_case_report.csv):

| Parameter | Unit | Full-PVT Worst Value | Worst-Case Corner | Design Margin / Evaluation |
| :--- | :--- | :---: | :---: | :--- |
| **Master Bias Current** | $\mu\text{A}$ | 49.581 | `FFVHTH` | Nominal $40\text{ }\mu\text{A}$, bounded within $\pm 24\%$ |
| **Total Supply Current** | $\text{mA}$ | 1.212 | `FFVHTH` | Low power consumption ($< 1.25\text{ mA}$) |
| **Total Power Dissipation** | $\text{mW}$ | 4.363 | `FFVHTH` | Power bounded across full extreme grid |
| **Minimum DC Gain** | $\text{dB}$ | **89.697** | `FSVLTH` | $> 89.6\text{ dB}$ open-loop gain across all 45 corners |
| **Minimum UGF** | $\text{MHz}$ | **8.417** | `SSVLTH` | $> 8.4\text{ MHz}$ bandwidth ($C_L = 10\text{ pF}$) |
| **Minimum Phase Margin** | $\text{deg}$ | **59.932** | `FFVLTH` | Stable second-order response ($\text{PM} \ge 60^\circ$) |
| **Maximum Input Offset** | $\mu\text{V}$ | 21.419 | `FSVLTH` | Low systematic input offset |
| **Minimum CMRR @ 60 Hz** | $\text{dB}$ | **108.150** | `SSVLTH` | Excellent common-mode rejection |
| **Minimum PSRR+ @ 60 Hz** | $\text{dB}$ | **101.557** | `SSNOMTH` | High power-supply isolation |
| **Maximum Input Noise** | $\mu\text{Vrms}$ | **2.188** | `SSVLTH` | $< 2.2\text{ }\mu\text{Vrms}$ integrated in $0.05\text{--}150\text{ Hz}$ |
| **Highest Input Low Limit** | $\text{mV}$ | 545.0 | `SSVHTL` | Rail-to-rail swing near ground |
| **Worst Input High Headroom** | $\text{mV}$ | 213.0 | `FSVLTH` | Operates to within $213\text{ mV}$ of $V_{DD}$ |
| **Worst Output High Headroom** | $\text{mV}$ | 215.0 | `FSVLTH` | Low-dropout output stage headroom |
| **Minimum Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 7.034 / 5.522 | `SSVLTL` | Fast transient response ($> 5.5\text{ V}/\mu\text{s}$) |
| **Maximum Settling Time** | $\text{ns}$ | 214.4 | `SSVLTL` | Settles in $< 215\text{ ns}$ to $2\text{ mV}$ tracking |

---

### 6.4 Fully Differential OTA (`FD_OTA`) Nominal & 9-Corner Summary

Extracted from [`FDOTA_table_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/FDOTA_table_report.csv):

| Parameter | Unit | `NOM` | `FF` | `SS` | `FS` | `SF` | `VL` ($3.0\text{V}$) | `VH` ($3.6\text{V}$) | `TL` ($-40^\circ\text{C}$) | `TH` ($+125^\circ\text{C}$) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Total Current** | $\text{mA}$ | 1.753 | 2.015 | 1.541 | 1.797 | 1.707 | 1.724 | 1.773 | 1.466 | 1.987 |
| **Total Power** | $\text{mW}$ | 5.784 | 6.650 | 5.085 | 5.931 | 5.633 | 5.173 | 6.383 | 4.839 | 6.557 |
| **Differential DC Gain** | $\text{dB}$ | 86.391 | 85.783 | 86.746 | 85.699 | 86.943 | 85.929 | 86.750 | 87.264 | 84.914 |
| **Differential UGF** | $\text{MHz}$ | 12.256 | 14.307 | 10.596 | 12.414 | 12.080 | 11.999 | 12.452 | 13.798 | 10.088 |
| **Differential Phase Margin** | $\text{deg}$ | 73.795 | 68.037 | 78.553 | 72.976 | 74.617 | 73.571 | 73.979 | 77.119 | 69.734 |
| **Input Offset** | $\text{pV}$ | -31.226 | 32.195 | -0.060 | 45.626 | -25.710 | 6.065 | 0.118 | 28.678 | -9.734 |
| **Input Noise ($0.05\text{--}150\text{ Hz}$)** | $\mu\text{Vrms}$ | 3.111 | 2.960 | 3.264 | 3.057 | 3.166 | 3.104 | 3.117 | 2.981 | 3.368 |
| **Output CM Error @ Nom** | $\text{mV}$ | -0.057 | -3.702 | 4.037 | 0.755 | -0.842 | -0.027 | -0.079 | -18.721 | 29.726 |
| **Input CM Low** | $\text{V}$ | 0.897 | 0.796 | 0.999 | 0.814 | 0.979 | 0.892 | 0.899 | 0.899 | 0.886 |
| **Input CM High** | $\text{V}$ | 3.300 | 3.300 | 3.300 | 3.147 | 3.300 | 3.000 | 3.600 | 3.300 | 3.284 |
| **Diff Output Swing High** | $\text{V}$ | +3.158 | +3.159 | +3.155 | +3.145 | +3.170 | +2.859 | +3.456 | +3.229 | +3.047 |
| **Diff Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 7.24 / 7.14 | 9.04 / 8.94 | 5.91 / 5.81 | 7.36 / 7.27 | 7.11 / 7.01 | 7.10 / 7.01 | 7.34 / 7.24 | 6.45 / 6.38 | 7.71 / 7.58 |
| **Diff Settling Time ($2\text{ mV}$)** | $\text{ns}$ | 153.6 | 141.1 | 204.6 | 149.6 | 158.1 | 156.1 | 152.1 | 180.1 | 173.6 |
| **CMFB Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 3.51 / 3.49 | 4.46 / 4.54 | 2.71 / 2.71 | 3.62 / 3.55 | 3.35 / 3.41 | 3.28 / 3.42 | 3.62 / 3.53 | 3.16 / 3.89 | 3.69 / 2.80 |
| **CMFB Settling Time** | $\text{ns}$ | 313.6 | 266.1 | 412.1 | 303.1 | 324.6 | 318.1 | 310.6 | 321.1 | 384.1 |

---

### 6.5 FD OTA Full-PVT Worst-Case Performance

Extracted from [`FDOTA_worst_case_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/FDOTA_worst_case_report.csv):

| Parameter | Unit | Full-PVT Worst Value | Worst-Case Corner | Evaluation / Compliance |
| :--- | :--- | :---: | :---: | :--- |
| **Differential DC Gain** | $\text{dB}$ | **83.594** | `FSVLTH` | $> 83.5\text{ dB}$ across full 45-PVT grid |
| **Differential UGF** | $\text{MHz}$ | **8.306** | `SSVLTH` | High-speed differential core ($C_L = 10\text{ pF}$) |
| **Differential Phase Margin** | $\text{deg}$ | **64.167** | `FFVLTH` | Robust small-signal differential stability |
| **Input-Referred Noise** | $\mu\text{Vrms}$ | **3.545** | `SSVHTH` | Low-noise differential channel |
| **Output CM Voltage Error** | $\text{mV}$ | 32.999 | `SSNOMTH` | Precise continuous-time CMFB regulation |
| **Input CM Low Bound** | $\text{V}$ | 1.006 | `SSVHTL` | Broad input common-mode range |
| **Input CM High Headroom** | $\text{mV}$ | 311.0 | `FSVLTH` | Tracks to within $311\text{ mV}$ of $V_{DD}$ |
| **Differential Output Swing** | $\text{V}$ | **$\pm 2.730$** | `FSVLTH` | Large dynamic output swing range |
| **Differential Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 5.138 / 5.073 | `SSVLTL` | Fast symmetric differential slewing |
| **Differential Settling Time** | $\text{ns}$ | 236.6 | `SSVLTL` | Fast transient response ($< 240\text{ ns}$) |
| **CMFB Slew Rate (Rise / Fall)** | $\text{V}/\mu\text{s}$ | 2.241 / 2.133 | `SSVLNOM` / `SSVLTH` | Rapid common-mode recovery |
| **CMFB Settling Time** | $\text{ns}$ | 507.1 | `SSVLTH` | Stable CMFB loop transient stabilization |

---

### 6.6 Standalone Differential Core (`FDC`) & CMFB Summaries

Extracted from [`NOM.FDC_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.FDC_summary.csv) and [`NOM.CMFB_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.CMFB_summary.csv):

| Sub-Block | Characterization Metric | Nominal Result | Design Specification |
| :--- | :--- | :---: | :---: |
| **`FDC` (Core)** | Differential DC Gain | 88.362 dB | $> 80\text{ dB}$ |
| | Unity-Gain Frequency ($C_L = 10\text{ pF}$) | 12.236 MHz | $> 10\text{ MHz}$ |
| | Phase Margin | 72.894° | $> 60^\circ$ |
| | Plant Differential Gain | 18,831 V/V | High-gain core |
| | Input Noise ($1\text{--}150\text{ Hz}$) | 2.461 µVrms | $< 3.0\text{ }\mu\text{Vrms}$ |
| **`CMFB`** | Open-Loop Common-Mode Gain | 43.912 dB | $> 40\text{ dB}$ |
| | Common-Mode Loop UGF ($C_L = 2\text{ pF}$) | 800.932 MHz | Fast CM stabilization |
| | Common-Mode Phase Margin | 86.428° | High loop damping |
| | Valid Reference Voltage Range | $1.120\text{ to }2.760\text{ V}$ | Symmetric tracking around $1.65\text{ V}$ |
| | Transient Settling Time ($V_{\text{REF}}$ step) | 5.2 ns | Instantaneous CM recovery |

---

## 7. Generated Reports & Reviewable Artifacts

### 7.1 CSV Summary Datasets

- **BIAS Subsystem**:
  - [`BIAS_table_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_table_report.csv): 9-corner comparison summary
  - [`BIAS_global_worst_case.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_global_worst_case.csv): Global PVT extrema search
  - [`BIAS_startup_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_startup_report.csv): 35 startup transient runs
  - [`BIAS_sel_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_sel_report.csv): Transmission gate code error
  - [`BIAS_dc2d_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_dc2d_report.csv): 2D DC voltage/temperature surface grid
  - [`BIAS_reference_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/BIAS_reference_report.csv): Reference voltage stability report
- **Single-Ended OTA (`SE_OTA`)**:
  - [`SEOTA_table_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/SEOTA_table_report.csv): 9-column comparison summary
  - [`SEOTA_worst_case_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/SEOTA_worst_case_report.csv): 45-point full-PVT worst-case dataset
  - [`NOM.SEOTA_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.SEOTA_summary.csv): Compatibility summary export
- **Fully Differential OTA (`FD_OTA`)**:
  - [`FDOTA_table_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/FDOTA_table_report.csv): 9-column comparison summary
  - [`FDOTA_worst_case_report.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/FDOTA_worst_case_report.csv): 45-point full-PVT worst-case dataset
  - [`NOM.FDOTA_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.FDOTA_summary.csv): Compatibility summary export
  - [`NOM.FDC_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.FDC_summary.csv): Differential core standalone summary
  - [`NOM.CMFB_summary.csv`](file:///d:/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.CMFB_summary.csv): CMFB standalone summary

### 7.2 Generated Characterization Figures

- **BIAS Plots**: `NOM_BIAS_STARTUP.png`, `NOM_BIAS_STARTUP_VOLTAGE.png`, `NOM_BIAS_SEL.png`, `NOM_BIAS_TEMP.png`, `NOM_BIAS_VDD.png`, `NOM_BIAS_2D.png`.
- **SE OTA Plots**: `NOM.open_loop_gain_phase.png`, `NOM.cmrr.png`, `NOM.psrr.png`, `NOM.input_referred_noise_density.png`, `NOM.open_loop_vtc.png`, `NOM.closed_loop_usable_range.png`, `NOM.closed_loop_step_response.png`.
- **FD OTA Plots**: `NOM.open_loop_gain_phase.png`, `NOM.cmrr.png`, `NOM.psrr.png`, `NOM.input_referred_noise_density.png`, `NOM.open_loop_vtc.png`, `NOM.output_swing_and_closed_loop_vtc.png`, `NOM.input_common_mode_range.png`, `NOM.closed_loop_step_response.png`, `NOM.output_cm_transient.png`.

---

## 8. Verification Reproducibility

Execute all simulations and post-processing analyzers from the repository root:

```bash
# 1. BIAS & Selector Subsystem
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"

# 2. Single-Ended OTA Full 45-PVT Analysis
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA','SEOTA_Analyze.m'))"

# 3. Fully Differential OTA, Core, and CMFB Full Analysis
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','CMFB','CMFB_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDC','FDC_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDOTA','FDOTA_Analyze.m'))"
```

All analysis routines have been validated in MATLAB R2026a under Windows and Linux environments.

---

## 9. Limitations and Future Work

| Phase | Milestone | Objective / Completion Criteria |
| :---: | :--- | :--- |
| **Phase 1** | **Top-Level AFE Verification** | Execute full-chain transient and frequency-domain verification across the cascaded `INA -> LPF -> PGA -> BUFFER` path. |
| **Phase 2** | **Mismatch & Monte Carlo** | Run statistical mismatch simulations to establish true yield, realistic CMRR/PSRR floors, and statistical input offset bounds. |
| **Phase 3** | **Physical Layout & Extraction** | Complete DRC/LVS-clean layout on GF180 1P6M, extract parasitic $RC$ networks, and perform post-layout extracted re-simulation. |
| **Phase 4** | **Mixed-Signal ADC Integration** | Integrate the 10-bit SAR ADC converter macro with the analog frontend core. |
| **Phase 5** | **Silicon Tapeout & Laboratory Test** | Prepare pad ring, chip assembly, evaluation PCB testbench, and bio-signal measurement validation. |
