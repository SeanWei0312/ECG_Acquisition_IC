# ECG Analog Front-End Project Report

Updated 2026-10-17 from archived schematic-level analysis exports.

## 1. Project scope and architecture

This project implements an ECG analog front end in GF180MCU: low-noise amplification, low-pass filtering, programmable gain, common-mode feedback, bias distribution, and differential output buffering. The current scope ends at FDBUF. ADC development is not included.

This is an independent, self-directed project. The IEEE SSCS 2026 Chipathon environment is used as a technical reference only; this is not an official program submission or a tapeout through that program.

The report summarizes each implemented block. Detailed sizing calculations, complete corner tables, and full Monte Carlo statistics remain in the linked block reports. No new simulations were run for this document.

### Signal path

Electrodes → INA + RLD → LPF → PGA → FDBUF.

BIAS/MIRROR supply shared bias currents. SEOTA and FDOTA provide the amplifier cores; FDOTA contains FDC and CMFB. INV, TG, MUX, and MUXD implement selection and bypass control.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.sch)

![AFE circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

| Stage | Nominal target | Purpose |
| :--- | :--- | :--- |
| INA | 240 V/V | Amplify the differential electrode signal |
| RLD | Common-mode feedback | Suppress input common-mode interference |
| LPF | 1 V/V; −1 dB frequency ≥150 Hz | Preserve the ECG passband and attenuate higher frequencies |
| PGA | 2 / 4 / 8 / 16 V/V | Select signal-path gain |
| FDBUF | 1 V/V | Drive the specified differential capacitive loads |

The nominal gain plan is **480 / 960 / 1920 / 3840 V/V**. It is the product of stage targets, not a measured full-chain gain. Integrated AFE exports are not yet available.

### System design sequence

First place low-noise gain at the electrode interface. Keep LPF and FDBUF at unity gain, and make the later PGA programmable:

$$
G_{\mathrm{AFE}}=240\times1\times\{2,4,8,16\}\times1.
$$

For a ±2.4-V differential-output range, the corresponding planned electrode-input magnitudes are ±5.000, ±2.500, ±1.250, and ±0.625 mV. More gain improves small-signal output utilization but reduces the maximum input before clipping.

Next place the LPF before the PGA so programmable gain does not amplify as much out-of-band content. Place FDBUF last to isolate the PGA from the output capacitance. Keep RLD as an electrode/body common-mode loop, distinct from each FDOTA's internal output-common-mode loop.

For a flat-passband approximation with uncorrelated stage-added noise,

$$
e_{\mathrm{RTI}}^2\approx e_{\mathrm{INA}}^2+
\frac{e_{\mathrm{LPF}}^2+e_{\mathrm{PGA}}^2}{240^2}+
\frac{e_{\mathrm{BUF}}^2}{(240G_{\mathrm{PGA}})^2}.
$$

For example, nominal LPF noise of 6.173 µVrms contributes approximately 25.72 nVrms when referred through the preceding gain of 240. This explains the priority given to the INA's 2.677-µVrms nominal noise. Final integrated noise still requires frequency-dependent transfer functions and the complete circuit.

The block narratives below reconstruct design intent from implemented dimensions and analysis exports. A first-order estimate is not an independently optimized size, and agreement at nominal conditions does not replace PVT or mismatch verification.

### Conditions and interpretation

Nominal means NOM process, 3.3 V, and 27°C. PVT covers five processes and all nine combinations of 3.0/3.3/3.6 V with −40/27/125°C. `FFVHTH`, for example, means FF process at 3.6 V and 125°C.

Blank Spec cells are report-only. Worst means the analyzer-selected limiting value, not necessarily the largest number. A tested range bound is not an exact compression point. Very large deterministic rejection values can reflect symmetry and numerical cancellation; they are not silicon guarantees.

## 2. Power and bias blocks

### 2.1 BIAS — master bias generation

BIAS generates the PMOS bias voltage BP. The nominal current target is 40 µA. The nwell resistor uses W = 3.000 µm and L = 1.520 µm.

[Schematic source](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sch)

![BIAS circuit schematic](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/BIAS/BIAS.png)

**Design sequence.** Begin with the 40-µA reference target. Equal PMOS branch currents and a 1:30 PNP area ratio produce approximately \(V_T\ln30=87.97\) mV at 27°C. The unequal NMOS pair also contributes:

$$
I_{RS}R_S=V_T\ln30+V_{GS1}-V_{GS2}.
$$

MN1/MN2 use W/L = 24/4 and 16/4 µm. The wider MN1 lowers its required gate-source voltage at equal current, so RS cannot be calculated from \(\Delta V_{EB}/I\) alone.

The implemented 3/1.52-µm n-well resistor is approximately 785.7 Ω after model corrections. Matched 16/4-µm PMOS devices establish the current ratio; the weak 0.5/10-µm startup device initiates the loop without materially loading its final state.

**Design closure.** Simulation gives 40.018 µA nominal. The high-side PVT margin is only 0.534 µA, so current variation remains important despite excellent nominal agreement.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ibias | µA | 40±10 | 40.018 | 49.466 | FFVHTH |
| BP | V |  | 1.642 | 1.137 | FSVLTH |
| Total current | µA |  | 119.978 | 148.377 | FFVHTH |
| Total power | µW |  | 395.928 | 534.156 | FFVHTH |
| Mirror error | % | ±1 | -0.003 | 0.149 | FSVLTH |
| MST margin | V | >0 | 1.541 | 0.742 | FFVHTH |
| Startup time | µs |  | 807.522 | 3701.808 | SSVLTL |
| Temperature coefficient | ppm/°C |  | 1184.733 | 1235.503 | FFVL sweep |
| Line regulation | %/V |  | 4.293 | 5.322 | SSTL sweep |

The DC current spans **31.071–49.466 µA** against 30–50 µA limits. The high-side margin is 0.534 µA. Ibias worst case is selected by the largest deviation from 40 µA.

Ibias: nominal **40.018 µA**; worst **49.466 µA** at `FFVHTH`. The surface characterizes the separate 50,630-point voltage/temperature grid.

![NOM BIAS 2D.png](Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_2D.png)

Startup time: nominal **807.522 µs**; worst **3701.808 µs** at `SSVLTL`. All 45 archived startup cases completed with zero reported startup failures.

![NOM BIAS STARTUP.png](Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_STARTUP.png)

TC comparison values use VDD = 3.3 V; line regulation uses T = 27°C. Their worst cases search 15 temperature and 15 supply sweeps, respectively.

**FULL MC:** 200/200 valid samples; measured joint yield 100%. MM and GL also have 200/200 valid samples and 100% yield. These campaigns use nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/POWER_BLOCKS/BIAS_Report.md).

### 2.2 MIRROR — bias distribution

MIRROR copies the reference bias into the required branches. It is verified as part of the BIAS testbench and the amplifier operating-point checks, not as an independent 45-corner block campaign.

[Schematic source](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/MIRROR/MIRROR.sch)

![MIRROR circuit schematic](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/MIRROR/MIRROR.png)

**Design sequence.** Use equal master/output aspect ratios so \(I_{\mathrm{OUT}}/I_{\mathrm{REF}}\approx1\). Every distribution unit uses W/L = 16/4 µm, matching the master PMOS.

The long channel reduces drain-voltage sensitivity; equal geometry improves matching. Larger area increases BP-node capacitance, while unequal output voltages still cause current error.

**Design closure.** The measured mirror path reaches 0.149% maximum deterministic error against ±1%. That check does not establish equal accuracy for every differently loaded integrated branch.

The BIAS testbench reports a nominal mirror error of **−0.003%**, a full-DC-PVT maximum magnitude of **0.149%**, and a **±1%** limit. These values apply to the measured mirror path, not automatically to every loaded branch in the integrated AFE.

[Detailed design, measurements, plots, and source exports](Report/POWER_BLOCKS/BIAS_Report.md).

## 3. Amplifier building blocks

### 3.1 SEOTA — single-ended amplifier

SEOTA is a two-stage Miller-compensated amplifier. Its verification combines open-loop gain/stability/noise measurements with closed-loop accuracy, range, and transient tests at a 10-pF load.

[Schematic source](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.sch)

![SEOTA circuit schematic](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.png)

**Design sequence.** Start with the 10-pF load and approximately 20-µA tail current. An 8-V/µs nominal slew target permits \(C_c\le2.51\) pF; choose 2 pF for pole splitting with slew margin.

The 10-MHz nominal UGF target then requires

$$
g_{m1}=2\pi f_uC_c=125.7\ \mu\mathrm S.
$$

At L = 4 µm and \(g_m/I_D=20\) V⁻¹, the lookup calculation gives 6.283 µA and W = 192.1 µm. The implemented input pair uses 400 µm effective width per device for noise and matching; its final mirror allocation supplies approximately 10 µA per branch.

Shorter 0.5-µm output devices provide current density and speed. The 2-pF capacitor and approximately 3.8-kΩ nulling resistor trade crossover frequency against phase margin. Enlarging the input pair reduces noise but adds capacitance.

**Design closure.** Nominal UGF is 12.842 MHz and noise is 1.873 µVrms. Worst phase margin is only 1.371° above its 55° limit, making extracted-node capacitance a significant risk.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤1.25 | 0.825 | 1.107 | FFVHTH |
| DC gain | dB | ≥88 | 96.522 | 93.985 | FSVLTH |
| UGF | MHz | ≥8 | 12.842 | 8.767 | SSVLTH |
| Phase margin | ° | ≥55 | 67.773 | 56.371 | FFVLTH |
| Input offset | µV | ±2000 | 3.198 | 12.101 | FSVLTH |
| Input-referred noise 0.05-150 Hz | µVrms | ≤2.5 | 1.873 | 2.189 | SSVLTH |
| Input low | mV | ≤600 | 154 | 430 | SSVHTL |
| Input high | V | ≥2.75 | 3.237 | 2.814 | FSVLTH |
| SR rise | V/µs | ≥6.5 | 9.819 | 6.931 | SSVLTL |
| SR fall | V/µs | ≥5.0 | 7.971 | 5.64 | SSVLTL |
| Settling time | ns | ≤225 | 162.9 | 213.4 | SSVLTL |

Phase margin: nominal **67.773 °**; worst **56.371 °** at `FFVLTH`. UGF is 12.842 MHz nominal and 8.767 MHz at the limiting PVT corner.

![NOM.open loop gain phase.png](Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.open_loop_gain_phase.png)

Settling time: nominal **162.9 ns**; worst **213.4 ns** at `SSVLTL`. The phase-margin and transient limits remain important post-layout checks.

![NOM.closed loop step response.png](Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.closed_loop_step_response.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/ANALOG_BLOCKS/SEOTA_Report.md).

### 3.2 FDOTA — fully differential amplifier

FDOTA combines two-stage differential amplification with common-mode feedback. The integrated OL/CL benches use 40 pF per output. Differential and common-mode responses are evaluated separately.

[Schematic source](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sch)

![FDOTA circuit schematic](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.png)

**Design sequence.** Size the differential path for 40 pF per output, then close CMFB around the actual output sensor. With 2.5-pF compensation per side and a 10-MHz nominal UGF target,

$$
g_{m1}=2\pi(10\ \mathrm{MHz})(2.5\ \mathrm{pF})
=157.1\ \mu\mathrm S.
$$

The input pair uses L = 2 µm and effective W = 200 µm per device, enlarged from the 105.1-µm first-pass result for noise and matching. Each output branch uses a 500-µm PMOS and 100-µm NMOS at L = 0.5 µm for drive capability.

Matched 2.5-pF/3.5-kΩ compensation branches preserve symmetry and provide pole splitting and zero placement. More compensation improves robustness but reduces bandwidth and slew rate.

**Design closure.** Estimated gain is 93.13 dB versus 92.064 dB nominal simulation. Integrated differential and common-mode transients validate the coupled system; standalone fixture responses are not substitutes.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤2.5 | 1.605 | 2.196 | FFVHTH |
| Differential DC gain | dB | ≥85 | 92.064 | 90.321 | FFVLTH |
| Differential UGF | MHz | ≥8 | 14.586 | 9.415 | SSVLTH |
| Differential phase margin | ° | ≥60 | 77.134 | 69.171 | FFVLTH |
| Input differential offset | µV | ±3000 | 0 | 0 | SFVHNOM |
| Output CM error | mV | ±20 | -0.132 | 11.982 | SSVHTH |
| Input CM low | mV | ≤1000 | 870 | 975 | SSVHNOM |
| Input-referred noise 0.05-150 Hz | µVrms | ≤4 | 3.083 | 3.513 | SSVHTH |
| Differential output swing high | V | ≥1.8 | 3.248 | 2.898 | FSVLTH |
| Differential SR rise | V/µs | ≥4 | 7.208 | 5.099 | SSVLTL |
| Differential settling time | ns | ≤300 | 175.867 | 246.549 | SSVLTL |
| Differential-step CM disturbance | mV | ≤60 | 37.052 | 47.416 | SSNOMTH |
| CMFB settling time | ns | ≤1000 | 309.735 | 418.338 | SSVLTH |

Differential UGF: nominal **14.586 MHz**; worst **9.415 MHz** at `SSVLTH`. The minimum phase margin is 69.171° against 60°.

![NOM.open loop gain phase.png](Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.open_loop_gain_phase.png)

Differential settling time: nominal **175.867 ns**; worst **246.549 ns** at `SSVLTL`. The corresponding differential-step CM disturbance reaches 47.416 mV worst case.

![NOM.closed loop step response.png](Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.closed_loop_step_response.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/ANALOG_BLOCKS/FDOTA_Report.md).

### 3.3 FDC — differential core

FDC supplies the differential forward path. Its isolated characterization uses a common-mode control input; those results must not be confused with the integrated FDOTA return ratio.

[Schematic source](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/FDC/FDC.sch)

![FDC circuit schematic](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/FDC/FDC.png)

**Design sequence.** The input pair sets transconductance; the active loads provide first-stage gain; two output branches drive equal capacitive loads. Input/load devices use L = 2 µm for gain and matching, while L = 0.5 µm output devices favor speed.

The 10/20-µm tail/reference widths give approximately half the 40-µA reference as tail current. Identical output and compensation branches reduce differential-to-common-mode conversion.

These choices serve the integrated FDOTA gain, noise, and settling requirements. Their component-by-component calculations remain in the detailed FDOTA report.

FDC nominal testbenches and MATLAB diagnostics support FDOTA sizing and debugging. Standalone fixture results are not project-level verification results. Integrated FDOTA nominal, PVT, and MC results are reported in Section 3.2.

[Detailed circuit sizing and integrated results](Report/ANALOG_BLOCKS/FDOTA_Report.md).

### 3.4 CMFB — common-mode regulation

CMFB senses the average output and adjusts the FDC load bias. The isolated bench includes an ideal plant; its very high crossover frequency is a test-fixture result, not the integrated FDOTA bandwidth.

[Schematic source](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/CMFB/CMFB.sch)

![CMFB circuit schematic](Design_Files/IC%20Design/Schematic/ANALOG_BLOCKS/FDOTA/CMFB/CMFB.png)

**Design sequence.** Matched 100-kΩ resistors and 50-fF capacitors sense average output voltage. The amplifier compares this common mode with REF and adjusts the FDC load bias.

A 40-µA tail gives approximately 20 µA per input branch. Selecting L = 1 µm and \(g_m/I_D\approx12\) V⁻¹ gives about 240 µS. The calculated input width is 14.18 µm; use 15 µm for matching margin.

A first-order 1% settling screen gives 0.733 MHz for the 1-µs requirement and 1.83 MHz for a 400-ns nominal target. The actual FDC plant and sensor must remain in final loop verification.

**Design closure.** Integrated CMFB settling is 309.735 ns nominal and 418.338 ns worst PVT. These are integrated FDOTA results, not ideal-plant fixture results.

CMFB nominal testbenches and MATLAB diagnostics support FDOTA sizing and debugging. Standalone fixture results are not project-level verification results. Integrated FDOTA nominal, PVT, and MC results are reported in Section 3.2.

[Detailed circuit sizing and integrated results](Report/ANALOG_BLOCKS/FDOTA_Report.md).

## 4. ECG signal-conditioning blocks

### 4.1 INA — instrumentation amplifier

The INA target is 240 V/V, formed by nominal S1 = 60 V/V and S2 = 4 V/V. It provides front-end gain before downstream filtering and programmable amplification.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/INA.sch)

![INA circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/INA.png)

**Design sequence.** Allocate gain as 60 V/V in the high-input-impedance SEOTA pair and 4 V/V in the FDOTA stage:

$$
G_{\mathrm{INA}}=
\left(1+\frac{2R_{\mathrm{SEF}}}{R_{\mathrm{SEG}}}\right)
\frac{R_{\mathrm{FDFB}}}{R_{\mathrm{FDIN}}}=240.
$$

A 4-kΩ gain resistor gives a first-pass 118-kΩ first-stage feedback value. A 10-kΩ second-stage input resistor requires 40-kΩ feedback. W = 4 µm is shared across INA resistors; implemented lengths account for PDK geometry and end-resistance effects.

Large first-stage gain reduces later-stage input-referred noise but consumes bandwidth and input range. The second stage completes the gain without demanding the full ratio from one amplifier.

**Design closure.** Measured nominal gains are 60.001 and 4.000 V/V, giving 240.027 V/V overall. Worst input noise is 3.107 µVrms against 4 µVrms.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤6.2 | 3.862 | 4.815 | FFVHTH |
| INA gain | V/V |  | 240.027 | 239.815 | SSVLTL |
| INA gain error | % | ±0.5 | 0.011 | -0.077 | SSVLTL |
| Gain flatness 0.05-150 Hz | dB | ≤0.1 | 1.432e-06 | 2.246e-06 | SSVLTH |
| INA -3 dB bandwidth | kHz |  | 259.251 | 207.051 | SSVLTH |
| Input-referred noise 0.05-150 Hz | µVrms | ≤4 | 2.677 | 3.107 | SSVLTH |
| Input range high | mV | ≥5 | 12.8 | 11.2 | SSVLTH |
| Output range high | V | ≥1.2 | 3.071 | 2.687 | SSVLTH |
| THD @ 60 Hz, 5 mVpp | % | ≤0.05 | 9.267e-05 | 1.025e-04 | SFVLTH |

INA gain: nominal **240.027 V/V**; worst **239.815 V/V** at `SSVLTL`. Bandwidth is characterization only; gain flatness has the direct passband requirement.

![NOM.INA RLD differential ac.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_differential_ac.png)

Input-referred noise 0.05-150 Hz: nominal **2.677 µVrms**; worst **3.107 µVrms** at `SSVLTH`. The front-end noise requirement remains ≤4 µVrms.

![NOM.INA RLD noise.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_noise.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/AFE_BLOCKS/INA_RLD_Report.md).

### 4.2 RLD — input common-mode feedback

RLD uses the sensed common-mode signal to drive the body model through the safety path. Its important checks are loop phase margin and common-mode suppression, not a standalone bandwidth target. INA and RLD share the same verification campaign.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/RLD.sch)

![RLD circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/RLD.png)

**Design sequence.** Equal 4-MΩ input resistors average the sensed signals. A 10-MΩ feedback resistor gives common-mode controller gain magnitude

$$
|G_{\mathrm{CM}}|\approx\frac{2R_F}{R_{\mathrm{IN}}}=5.
$$

For a feedback pole near 200 Hz, \(C_F=1/(2\pi R_Ff_p)=79.6\) pF. Use 80 pF, implemented as four 100 × 100 µm MIM units.

Large resistors minimize loading but need substantial area and parasitic control. More capacitance improves roll-off while reducing mains-frequency loop gain.

**Design closure.** Nominal gain is 4.999 V/V. Acceptance uses complete body/electrode-loop phase margin and suppression, not the controller RC pole alone.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| RLD gain | V/V |  | 4.999 | 4.999 | FSVLTH |
| RLD phase margin | ° | ≥60 | 64.006 | 62.118 | SSVLTH |
| Input CM suppression @ 60 Hz | dB | ≥35 | 37.231 | 37.121 | SSVLTL |
| Input CM suppression @ 150 Hz | dB | ≥25 | 27.735 | 27.309 | SSVLTL |
| RTI residual - MIS-P | µVpp | ≤1000 | 8.519 | 9.247 | SSVLTL |
| RTI residual - MIS-N | µVpp | ≤1000 | 8.519 | 9.247 | SSVLTL |

RLD phase margin: nominal **64.006 °**; worst **62.118 °** at `SSVLTH`. The formal minimum is 60°.

![NOM.INA RLD loop gain.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_loop_gain.png)

Input CM suppression @ 60 Hz: nominal **37.231 dB**; worst **37.121 dB** at `SSVLTL`. The 150-Hz minimum is 27.309 dB against a 25-dB requirement.

![NOM.INA RLD cm rejection.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_cm_rejection.png)

[Detailed design, measurements, plots, and source exports](Report/AFE_BLOCKS/INA_RLD_Report.md).

### 4.3 LPF — differential low-pass filter

The LPF target is unity gain. The −1 dB frequency must remain at or above 150 Hz; the −3 dB point and standalone noise are characterization quantities.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/LPF.sch)

![LPF circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/LPF.png)

**Design sequence.** Equal input and feedback resistors establish unity differential gain. A capacitor across each feedback resistor gives

$$
H_d(s)\approx\frac{1}{1+sR_FC_F},
\qquad f_{-1\mathrm{dB}}=0.50885f_p.
$$

The 150-Hz passband requirement implies \(f_p\ge294.8\) Hz. Choose a nominal pole near 500 Hz for RC margin. With 60 pF per side, the initial resistance is about 5.3 MΩ.

Use 1/2500-µm poly resistors and four 75 × 100 µm MIM units per feedback branch. Corrected resistance is approximately 5.219 MΩ, giving a 508.2-Hz pole estimate. Narrow resistors save area but increase matching/parasitic sensitivity.

**Design closure.** Simulation gives 506.908 Hz at −3 dB, within about 0.26% of the reduced-model estimate. The worst −1 dB frequency remains 174.134 Hz, above 150 Hz.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤2.5 | 1.605 | 2.196 | FFVHTH |
| Passband gain | V/V |  | 1 | 1 | SSVLTL |
| Passband gain error | % | ±0.5 | -0.024 | -0.048 | SSVLTL |
| LPF -1 dB frequency | Hz | ≥150 | 258.688 | 174.134 | SSVHTL |
| LPF -3 dB frequency | Hz |  | 506.908 | 340.983 | SSVHTL |
| Input range high | V | ≥1.2 | 3.158 | 2.798 | FSVLTH |
| Output CM error | mV | ±20 | -0.132 | 11.997 | SSVHTH |
| Input-referred noise 0.05-150 Hz | µVrms |  | 6.173 | 7.033 | SSVHTH |
| THD @ 60 Hz, 1.2 Vpp | % | ≤0.05 | 0.004 | 0.006 | SSVHTL |

LPF -1 dB frequency: nominal **258.688 Hz**; worst **174.134 Hz** at `SSVHTL`. The nominal attenuation at 150 Hz and complete curve remain in the detailed report.

![NOM.LPF differential ac.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_differential_ac.png)

Input range high: nominal **3.158 V**; worst **2.798 V** at `FSVLTH`. The required differential operating range includes ±1.2 V.

![NOM.LPF vtc.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_vtc.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/AFE_BLOCKS/LPF_Report.md).

### 4.4 PGA — programmable differential gain

The PGA selects G2/G4/G8/G16. Its 45-corner campaign contains 180 gain/corner combinations. Each gain must meet ±1% gain accuracy, its specified operating range, and ≤0.05% THD.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/PGA/PGA.sch)

![PGA circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/PGA/PGA.png)

**Design sequence.** Fix input resistance near 20 kΩ and calculate \(R_F=GR_{\mathrm{IN}}\). Gains 2/4/8/16 require effective feedback values of 40/80/160/320 kΩ.

Use selectable 40/40/120/120-kΩ sections per side. At W = 2 µm, first-pass lengths are 40/40/120/120 µm; final lengths are 40.04/40.32/121.28/121.14 µm.

Transmission gates use NMOS W/L = 25/0.28 µm and PMOS W/L = 50/0.28 µm. Wider switches reduce on-resistance error but increase charge injection and feedback-node capacitance.

The ±2.4-V output requirement gives input magnitudes \(2.4/G=\{1.2,0.6,0.3,0.15\}\) V. This sets the gain-dependent range tests.

**Design closure.** G2 has the largest gain error, 0.409% worst PVT. G16 has the closest input-range margin, approximately ±0.160 V against ±0.150 V required.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤2.5 | 1.605 | 2.196 | FFVHTH |
| Output CM error | mV | ±20 | -0.132 | 11.992 | SSVHTH |
| G2 gain error | % | ±1 | -0.011 | 0.409 | SSVLTH |
| G4 gain error | % | ±1 | -0.001 | 0.12 | SSVLTH |
| G8 gain error | % | ±1 | 0.002 | 0.133 | SSVLTH |
| G16 gain error | % | ±1 | 0.001 | -0.053 | FFVLTL |
| G2 THD @ 60 Hz, 1.20 Vpp | % | ≤0.05 | 0.015 | 0.023 | FSVLTL |
| G4 THD @ 60 Hz, 0.60 Vpp | % | ≤0.05 | 0.004 | 0.006 | FSVLTL |
| G8 THD @ 60 Hz, 0.30 Vpp | % | ≤0.05 | 2.146e-04 | 5.248e-04 | SSVLTL |
| G16 THD @ 60 Hz, 0.15 Vpp | % | ≤0.05 | 2.296e-04 | 4.064e-04 | FFVLTH |
| G16 input range low | V | ≤-0.15 | -0.186 | -0.16 | FSVLTH |
| G16 input range high | V | ≥0.15 | 0.186 | 0.16 | FSVLTH |
| G16 output range high | V | ≥2.4 | 2.968 | 2.562 | FSVLTH |

All THD stimuli target the same ideal **2.4 Vpp differential output**, at zero imposed offset. This differs from the VTC requirement of ±2.4 V differential output.

G2 gain error: nominal **-0.011 %**; worst **0.409 %** at `SSVLTH`. The figure compares all four gain configurations; bandwidth remains report-only.

![NOM.PGA differential ac.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/PGA/Plots/NOM.PGA_differential_ac.png)

G16 input range high: nominal **0.186 V**; worst **0.16 V** at `FSVLTH`. G16 requires ±0.15 V input and ±2.4 V output; do not treat the sweep endpoint as an exact compression crossing.

![NOM.PGA vtc.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/PGA/Plots/NOM.PGA_vtc.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/AFE_BLOCKS/PGA_Report.md).

### 4.5 FDBUF — differential output buffer

FDBUF is a unity-gain output stage. Loads of 40, 60, 80, and 100 pF per output are verified across PVT; CL60 is the nominal shared operating-point load. The hard transient requirement is ≤1 µs to enter and remain within ±0.05%.

[Schematic source](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/FDBUF/FDBUF.sch)

![FDBUF circuit schematic](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/FDBUF/FDBUF.png)

**Design sequence.** Equal input/feedback resistors give unity differential gain. A 20-kΩ target at W = 2 µm requires L = 20 µm; all four resistors use that geometry.

Unity signal gain still gives approximate noise gain two. With FDOTA UGF = 14.586 MHz, the one-pole bandwidth scale is 7.29 MHz before load-dependent poles and peaking.

A 100-mV differential step moves each side by approximately 50 mV. The load envelope therefore requires 2–5 pC per output. Charge delivery is necessary, but loop damping determines high-accuracy settling.

**Design closure.** At CL60, \(t_{0.05\%}\approx1.210/BW\) predicts 0.143 µs from 8.437 MHz; simulation gives 0.319 µs. This difference demonstrates the non-single-pole loaded response. Worst CL100 settling is 0.514 µs against 1 µs.

| Parameter | Unit | Spec | NOM | PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤2.5 | 1.605 | 2.196 | FFVHTH |
| Output CM error | mV | ±20 | -0.132 | 11.997 | SSVHTH |
| Input offset | mV | ±10 | -6.329e-07 | 1.440e-06 | SSVHTL |
| CL40 gain error | % | ±1 | -0.008 | -0.011 | FFVLTH |
| CL60 gain error | % | ±1 | -0.008 | -0.011 | FFVLTH |
| CL80 gain error | % | ±1 | -0.008 | -0.011 | FFVLTH |
| CL100 gain error | % | ±1 | -0.008 | -0.011 | FFVLTH |
| CL40 0.05% settling time | µs | ≤1 | 0.225 | 0.282 | SSVLTH |
| CL60 0.05% settling time | µs | ≤1 | 0.319 | 0.36 | FSVLTH |
| CL80 0.05% settling time | µs | ≤1 | 0.364 | 0.432 | SSVHTH |
| CL100 0.05% settling time | µs | ≤1 | 0.399 | 0.514 | SSVLTH |
| CL100 -3 dB bandwidth | MHz |  | 7.334 | 4.757 | SSVLTH |
| CL100 Overshoot | % |  | 12.768 | 18.495 | FFVHTL |

CL100 -3 dB bandwidth: nominal **7.334 MHz**; worst **4.757 MHz** at `SSVLTH`. The curve shows all four loads at the nominal process/environment.

![FDBUF differential response.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/Plots/FDBUF_differential_response.png)

CL100 0.05% settling time: nominal **0.399 µs**; worst **0.514 µs** at `SSVLTH`. Overshoot is report-only; the internal settling calculation still uses the ±0.05% criterion.

![FDBUF settling response.png](Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/Plots/FDBUF_settling_response.png)

**FULL MC:** 200/200 valid samples; exported joint yield 100%. This applies to measured MC quantities at nominal supply and temperature.

[Detailed design, measurements, plots, and source exports](Report/AFE_BLOCKS/FDBUF_Report.md).

## 5. Selector and control cells

These cells support internal/external signal selection and bypass operation. Their schematics are included for hierarchy completeness. Standalone delay, leakage, on-resistance, distortion, or digital timing signoff is not available in the current project exports.

### INV

Generates the complementary control polarity used by the selection logic.

**Design choice.** Use NMOS W/L = 1/0.5 µm and PMOS W/L = 2/0.5 µm. The wider PMOS qualitatively compensates for lower mobility. Modest widths limit control loading; larger devices would charge switch gates faster but increase switching current and capacitance. Timing is not established by the static analog tests.

[Schematic source](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/INV/INV.sch)

![INV circuit schematic](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/INV/INV.png)

### TG

Provides the complementary MOS transmission path. Its sizing affects analog loading and distortion; no independent TG linearity result is claimed here.

**Design choice.** Use parallel NMOS/PMOS devices at 25/0.28 and 50/0.28 µm. Complementary conduction reduces the signal-range weakness of a single MOS switch. Short channels and large widths reduce on-resistance, at the cost of charge injection, feedthrough, and capacitive loading.

[Schematic source](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/TG/TG.sch)

![TG circuit schematic](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/TG/TG.png)

### MUX

Selects the single-ended bias-control path in the BIAS testbench.

**Design sequence.** Combine two transmission paths with complementary selection. Reuse the INV/TG sizes rather than introducing another analog-switch geometry. The chosen path must preserve BP and mirror compliance; the static selector checks assess this, while startup tests assess recovery with the selected bias source.

[Schematic source](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/MUX/MUX.sch)

![MUX circuit schematic](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/MUX/MUX.png)

### MUXD

Selects differential internal/external signal paths in the AFE block testbenches.

**Design sequence.** Duplicate the selection path for the two differential halves and use common controls. Symmetric signal paths reduce conversion of switching imbalance into differential error. Evaluate the delivered OUT waveform with its load; correct internal-node behavior alone does not verify output settling or glitch suppression.

[Schematic source](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/MUXD/MUXD.sch)

![MUXD circuit schematic](Design_Files/IC%20Design/Schematic/DIGITAL_BLOCKS/MUXD/MUXD.png)

The block-level selector transients provide in-context functional evidence, not full digital-cell characterization.

![PGA selector functional trace](Measurement_Results/IC_Simulation/AFE_BLOCKS/PGA/Plots/NOM.PGA_SEL_functional_check.png)

The PGA trace compares internal, external, control, and selected differential signals under the nominal selector test. Further details remain in the [PGA report](Report/AFE_BLOCKS/PGA_Report.md).

## 6. Project-level verification status

| Block campaign | PVT conditions | MM valid / yield | GL valid / yield | FULL valid / yield |
| :--- | :--- | :--- | :--- | :--- |
| BIAS | 45 + 50,630-point DC grid | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| SEOTA | 45 | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| FDOTA | 45 | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| INA_RLD | 45 | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| LPF | 45 | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| PGA | 45 × 4 gains | 200/200; 100% | 200/200; 100% | 200/200; 100% |
| FDBUF | 45 × 4 loads | 200/200; 100% | 200/200; 100% | 200/200; 100% |

MM means local mismatch; GL means global variation; FULL combines both at the nominal environment. A finite set of nominal-environment MC samples does not establish mismatch yield at every PVT extreme. The analyzer’s non-valid/failed count may include missing or invalid files, not only demonstrated circuit failures.

### Completed versus pending

| Item | Current evidence | Remaining work |
| :--- | :--- | :--- |
| Block schematic verification | Exported PVT and MC tables for the measured blocks | Repeat verification after layout and extraction |
| Integrated AFE | Top schematic and MATLAB analyzer exist | Generate full-chain gain, noise, rejection, RLD-loop, and transient results |
| Selector/control cells | Schematics and in-context functional traces | Independent cell characterization if required by the implementation |
| Physical implementation | Schematic-level results only | Layout, DRC/LVS, extraction, and re-verification |
| Measured silicon | No measurements reported | Not part of the present evidence |

Individual block passes are not an integrated AFE pass. Do not sum independently selected worst-case currents or combine unrelated corners as though they were a simulated system operating point.

## 7. Design method and reproducibility

The OTA reports retain the step-by-step $g_m/I_D$ sizing flow: specification → required $g_m$ → current → current density → width → compensation → simulation comparison. Component-level reasons and trade-offs remain in those detailed reports.

The signal-chain design follows the same requirement-to-component sequence:

| Block | Starting requirement | Calculated design choice | Verification used to close the design |
| :--- | :--- | :--- | :--- |
| BIAS/MIRROR | 40-µA reference and accurate distribution | MOS/BJT loop equation, 1:30 PNP ratio, model-corrected RS, matched unit mirrors | Current range, mirror error, and startup |
| INA | 240-V/V gain with low input-referred noise | 60 × 4 gain allocation and matched feedback ratios | Gain accuracy, noise, usable range, and THD |
| RLD | Mains/common-mode suppression with stable feedback | Gain-five controller and approximately 80-pF feedback capacitor | Complete-loop phase margin and suppression |
| LPF | −1 dB frequency ≥150 Hz at unity gain | Approximately 500-Hz nominal pole; matched multi-megaohm resistors and 60-pF feedback branches | Passband loss, frequency margin, and THD |
| PGA | Gains 2/4/8/16 and ±2.4-V output range | 20-kΩ input network and switched 40/40/120/120-kΩ feedback sections | Gain-dependent error, range, and distortion |
| FDBUF | Unity gain and 0.05% settling ≤1 µs into 40–100 pF per output | Equal 20-kΩ input/feedback resistors around the FDOTA | Delivered-output settling across all four loads |

These are reconstructed design explanations, not a claim that every final dimension follows from one closed-form optimum. The block reports distinguish raw sheet-resistance estimates, PDK corrections, implemented geometries, and measured circuit behavior.

- [Device characterization and lookup plots](Report/SIZING/Gm_Id_Report.md)
- [Integrated AFE verification scope](Report/AFE_BLOCKS/AFE_Report.md)

SEOTA and FDOTA are evaluated in open-loop and closed-loop configurations. PVT sweeps cover process, supply, and temperature; separate MM, GL, and FULL campaigns assess mismatch and global variation.

FDC and CMFB fixtures isolate differential amplification, common-mode control sensitivity, and feedback polarity during design. Integrated FDOTA simulation evaluates their interaction with the actual output sensor and load.

Run ngspice to completion before invoking MATLAB. The analyzers read existing files; they do not launch simulations. Detailed CSVs and block reports are the source for the summaries above. No result files, specifications, circuits, or analyzers were changed for this document.

## 8. Conclusions and next steps

The project has a documented transistor-level AFE hierarchy, numerical block verification, and nominal functional traces. The current evidence supports continued AFE implementation and integration work; it does not establish extracted-layout or silicon performance.

1. Simulate the integrated AFE at every programmed gain with the intended output loads.
2. Complete layout and extraction, then repeat the existing acceptance limits.
3. Track phase margin, offset, noise, usable swing, and settling across the extracted hierarchy.
