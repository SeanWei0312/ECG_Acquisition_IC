# ECG Acquisition IC Project Report

Last updated: 2026-08-15

Project stage: pre-layout schematic verification; nominal integrated PATH and PVT-characterized BIAS/SEL

## 1. Executive Summary

This project develops a GF180 integrated circuit for electrocardiogram (ECG) acquisition in the SSCS Chipathon 2026 flow. The current verified scope includes the bias/reference and internal/external selection block (`BIAS`/`SEL`) and the analog signal path (`PATH`). PATH verification covers the input amplifier, switched filter and selection network, programmable gain, output buffering, common-mode control, reset behavior, and right-leg drive (RLD).

The integrated path has two gain settings:

- G2: nominal overall differential gain of 480 V/V (53.625 dB).
- G16: nominal overall differential gain of 3840 V/V (71.687 dB).

Nominal PATH simulations cover operating point, differential AC response, differential transient response, CMRR, PSRR+/PSRR-, input-referred noise, common-mode and differential input offset, startup with and without reset, RLD, THD, and SNR. Dedicated BIAS/SEL simulations cover five process corners, seven transient environmental cases per process, and complete -40 C to 125 C / 3.0 V to 3.6 V DC surfaces. MATLAB post-processing generates compact CSV reports and current figures for both flows.

The last documented PATH results show approximately 8.857 mA total current, 29.23 mW total power, 3.245 uVrms input-referred noise over 0.05-150 Hz, about 20.25 dB RLD common-mode suppression at 60 Hz, and less than 0.101% THD in the tested 60 Hz and 150 Hz cases. The BIAS flow reports 39.997 uA nominal current, a 31.054-49.441 uA full-grid range, a worst startup time of 1180.295 us, and zero failures in 35 startup runs. The most important unresolved PATH issue is the very low transient gain at 0.05 Hz and 0.1 Hz compared with ordinary AC analysis. The BIAS NOM device-vector and DC2D exports also require regeneration before their device-level sweep extrema are complete.

## 2. Design Scope and Conditions

### 2.1 Objective

The intended signal chain amplifies low-amplitude differential ECG signals while rejecting electrode common mode, supply ripple, and interference. The front end is fully differential through `OUTP` and `OUTN`, maintains an output common mode near 1.65 V, supports two gain configurations, and uses RLD feedback to reduce input common-mode interference.

The 10-bit SAR ADC shown in the system-level specification is not yet integrated into the verified analog path. This report therefore describes the analog front end only.

### 2.2 Nominal Simulation Conditions

| Condition | Value | Status |
| --- | ---: | --- |
| Process/model set | GF180 nominal schematic models | Implemented |
| Temperature | 27 degC | Implemented |
| Supply voltage | 3.3 V | Implemented |
| Input/output common-mode target | 1.65 V | Implemented |
| Bias parameter | 40 uA | Implemented |
| Output load | 10 pF per output | Implemented |
| ECG analysis band | 0.05-150 Hz | Used for integrated noise and report points |
| Normal switched-capacitor clock | 500 Hz, 2 ms period | Implemented |
| Normal clock timing | 80 us rise, 80 us fall, 920 us pulse width | Implemented |
| THD clock timing | 20 us rise, 20 us fall, 980 us pulse width | Implemented |
| Differential transient stimulus | 10 uV peak differential sine | Implemented |
| G2 expected gain | 480 V/V, 53.625 dB | Implemented |
| G16 expected gain | 3840 V/V, 71.687 dB | Implemented |

These are testbench conditions or nominal design values, not post-layout or measured specifications.

## 3. IC Architecture and Implementation

### 3.1 Bias Reference and Selection

The BIAS block generates the internal `BPINT` and `VREFINT` references. The separate SEL block selects between those internal references and the external `BPEXT`/`VREFEXT` inputs to produce the distributed `BP` and `VREF` outputs:

```text
BIAS: BPINT/VREFINT ----+
                        +--> SEL --> BP/VREF
External: BPEXT/VREFEXT +
```

The BIAS characterization testbench also includes the 40 uA output mirror load and startup device. The reported `IDD` and power values are the exported BIAS+SEL supply quantities defined by the testbench, not complete-chip consumption.

### 3.2 Integrated Signal Path

The integrated testbenches instantiate the following analog hierarchy:

```text
VINP/VINN -> INA -> selection/filter path -> PGA -> output buffer -> OUTP/OUTN
     |                                                               |
     +-------------------------- RLD feedback ------------------------+
```

The analyzer defines the expected path gain as:

$$
A_{expected}=60\times4\times G_{PGA}
$$

The RLD block senses common-mode behavior and drives the body/electrode model in the transient RLD test. Reset tests exercise removal of a large differential DC condition and compare startup with reset against startup without reset.

### 3.3 Implemented Building Blocks

| Block | Design files | Verification status |
| --- | --- | --- |
| BIAS and SEL | `Schematic/BIAS/`, `Schematic/SEL/`, and `Testbench/BIAS/` | Five-process environmental transient and 2-D temperature/supply characterization implemented |
| INA, LPF, PGA, selectors, buffer, RLD | `Design_Files/IC Design/Schematic/` | Instantiated in the integrated PATH tests |
| Single-ended OTA | `Schematic/SE_OTA/` and `Testbench/SE_OTA/` | Nominal open-loop, closed-loop, noise, CMRR, and PSRR results present |
| Fully differential core | `Schematic/FD_OTA/FDC/` | Nominal AC, noise, offset, and plant results present |
| Common-mode feedback | `Schematic/FD_OTA/CMFB/` | Nominal open-loop and closed-loop results present |
| Fully differential OTA | `Schematic/FD_OTA/FDOTA/` | Nominal open-loop and closed-loop results present |
| Integrated PATH | `Testbench/PATH/` | AC, noise, and multi-case transient verification implemented |

### 3.4 Layout, ADC, and PCB Status

No completed integrated PATH layout, parasitic extraction, DRC/LVS result, ADC integration, PCB implementation, or laboratory measurement is reported yet. All results in this document are pre-layout simulations.

## 4. Verification Methodology

### 4.1 Tools and Testbenches

Xschem and ngspice generate raw text data. MATLAB R2025b has been used to analyze the data and generate plots and tables.

| Testbench | Analyses |
| --- | --- |
| `BIAS/BIAS_TB_{NOM,FF,SS,FS,SF}.sch` | Bias startup, internal/external selection, and 2-D temperature/VDD characterization |
| `PATH/AC/PATH_TB_AC.sch` | Operating point, differential AC response, CMRR, PSRR+, PSRR- |
| `PATH/NOISE/PATH_TB_NOISE.sch` | Output and input-referred noise |
| `PATH/TRAN/PATH_TB_TRAN.sch` | Differential response, transient CMRR/PSRR, offsets, startup/reset, RLD, THD |

The AC sweep spans 0.001 Hz to 10 kHz with 200 points per decade. The noise sweep spans 0.01 Hz to 1 kHz with 300 points per decade. The main MATLAB report marks 0.05 Hz, 60 Hz, 150 Hz, and 1 kHz where applicable.

### 4.2 Differential Transient Schedule

The differential sine begins after a 100 ms delay. MATLAB selects complete cycles from the end of each exported case.

| Frequency | Simulated cycles after delay | MATLAB analysis window |
| ---: | ---: | ---: |
| 0.05 Hz | 2 | final 1 cycle |
| 0.1 Hz | 4 | final 1 cycle |
| 0.5 Hz | 4 | final 1 cycle |
| 1 Hz | 4 | final 3 cycles |
| 10 Hz | 4 | final 3 cycles |
| 60 Hz | 11 | final 10 cycles |
| 150 Hz | 11 | final 10 cycles |
| 250 Hz | 11 | final 10 cycles |
| 500 Hz | 21 | final 20 cycles |
| 1 kHz | 21 | final 20 cycles |

### 4.3 Rejection, Offset, RLD, and THD Schedules

| Test | Stimulus/cases | Simulated cycles | MATLAB analysis window |
| --- | --- | ---: | ---: |
| Transient CMRR | 50 mV peak common mode; 60, 150, 250, 500 Hz, 1 kHz; G2/G16 | 31 | final 20 |
| Transient PSRR+ | 100 mV peak AVDD ripple; same frequencies and gains | 31 | final 20 |
| Transient PSRR- | 100 mV peak ground/VSS ripple; same frequencies and gains | 31 | final 20 |
| VCM offset | 0.5 mVpp/G16 and 5 mVpp/G2 at 60 Hz; offsets +/-500, +/-300, 0 mV | 12 driven | final 10 |
| Differential offset | Same signal cases and offset values | 12 driven | final 10 |
| RLD off/on | 100 mV peak, 60 Hz common mode with mismatched electrode model | 12 driven | final 10 |
| THD | 0.5 mVpp/G16 and 5 mVpp/G2 at 60 and 150 Hz | 31 | final 30 |
| Startup | G16 with 300 mV differential DC; reset on/off comparison | No sine-cycle rule | settling criteria |

For startup, MATLAB compares pre-reset (30-40 ms), reset (40-60 ms), and final (180-200 ms) windows. Settling is evaluated from 500 Hz clock-cycle averages rather than from sine cycles.

### 4.4 Calculation Rules

The differential and common-mode signals are:

$$
V_{out,diff}=V_{OUTP}-V_{OUTN}
$$

$$
V_{out,cm}=\frac{V_{OUTP}+V_{OUTN}}{2}
$$

For each selected transient window, the analyzer fits sine, cosine, and DC terms by least squares. Signals sharing a time vector and frequency are solved together. Differential gain is:

$$
A_d=\frac{V_{out,diff,pk}}{V_{in,diff,pk}}
$$

$$
A_{d,dB}=20\log_{10}(A_d)
$$

The reported percentage error is:

$$
Gain\ error(\%)=100\left(\frac{A_d}{A_{expected}}-1\right)
$$

Transient common-mode rejection is calculated from the fitted common-mode input, fitted differential output, and matching transient differential gain:

$$
CMRR=20\log_{10}\left(\frac{A_dV_{in,cm}}{V_{out,diff}}\right)
$$

PSRR+ and PSRR- use the same rule with the applied supply-ripple amplitude replacing $V_{in,cm}$. If a matching transient differential-gain case is unavailable, the analyzer falls back to the nominal gain $60\times4\times G_{PGA}$.

AC CMRR and PSRR are differential-path gain in dB minus the corresponding AC feedthrough gain in dB. These AC values are the ones printed in the compact G2/G16 report table.

Input-referred integrated noise is:

$$
V_{n,in,rms}=\sqrt{\int_{f_1}^{f_2}e_n^2(f)\,df}
$$

The reported THD fits H1 through H10 simultaneously on raw transient samples. Non-overlapping multiples of the 500 Hz clock are included as nuisance tones so that switching energy is not assigned to signal harmonics:

$$
THD(\%)=100\frac{\sqrt{V_2^2+V_3^2+\cdots+V_{10}^2}}{V_1}
$$

Output SNR uses the fitted fundamental RMS and the output noise integrated from 0.05 Hz to 150 Hz:

$$
SNR=20\log_{10}\left(\frac{V_{1,rms}}{V_{n,out,rms}}\right)
$$

The THD plot displays H2-H10 in dBc with H1 stated as 0 dBc. Both 60 Hz and 150 Hz subplots use the same -100 dBc to 0 dBc scale.

### 4.5 BIAS Process, Environment, and 2-D Sweep Flow

The BIAS analyzer processes five process corners (`NOM`, `FF`, `SS`, `FS`, and `SF`) and seven transient conditions per process:

| Condition | Temperature | VDD |
| --- | ---: | ---: |
| NOM | 27 C | 3.3 V |
| VL | 27 C | 3.0 V |
| VH | 27 C | 3.6 V |
| TL | -40 C | 3.3 V |
| TH | 125 C | 3.3 V |
| TLVL | -40 C | 3.0 V |
| THVH | 125 C | 3.6 V |

The resulting 35 transient runs use a 100 us supply-ramp delay, a ramp ending at 1.1 ms, and an automatically detected `INT -> EXT -> INT` selector sequence. Settled operating values are means over the final 10% of the initial INT plateau. The first compact table presents `NOM FF SS FS SF VL VH TL TH`: the process columns use nominal conditions, while VL/VH/TL/TH use the actual NOM-process environmental transient files.

For each run, the startup threshold is relative to that run's own settled current. Startup time is measured from the fixed 100 us VDD-ramp start to the final entry into the 90-110% band that remains valid through the initial INT interval. A settled current at or below 4 uA or the absence of a permanent band entry is counted as a startup failure.

Selector edges are excluded by trimming 10% of each detected plateau. The analyzer searches all 35 runs for the maximum absolute errors:

$$
e_{BP,INT}=BP-BPINT,\qquad e_{BP,EXT}=BP-BPEXT
$$

$$
e_{VREF,INT}=VREF-VREFINT,\qquad e_{VREF,EXT}=VREF-VREFEXT
$$

Each process also supplies a 166 x 61 DC grid: -40 C to 125 C in 1 C steps and 3.0 V to 3.6 V in 10 mV steps, for 10,126 coordinate pairs. Extrema are selected from the actual temperature/VDD coordinates. The principal calculations are:

$$
I_{BIAS,error}=100\frac{I_{BIAS}-40\ \mathrm{uA}}{40\ \mathrm{uA}}
$$

$$
Mirror\ error=100\frac{I_{BIAS}-I_{RS}}{I_{RS}},\qquad
VREF\ error=VREF-\frac{VDD}{2}
$$

$$
MST\ margin=VTH_{MST}-VGS_{MST}
$$

At VDD = 3.3 V, the reported temperature coefficient is the full-range current variation normalized by the 27 C current and the 165 C span:

$$
TC=\frac{I_{max}-I_{min}}{I_{27}\times165}\times10^6\ \mathrm{ppm/C}
$$

At 27 C, line regulation is the full 3.0-3.6 V current range normalized by the 3.3 V current and the 0.6 V span:

$$
Line\ regulation=100\frac{I_{max}-I_{min}}{I_{3.3}\times0.6}\ \%/V
$$

These two values are range-normalized summaries, not signed local slopes or fitted derivatives.

## 5. Simulation Results

Sections 5.1-5.7 retain values from the last generated `PATH_summary.csv` and `PATH_table_report.csv` result set. The corresponding PATH CSVs and PNGs are currently absent from the worktree; these nominal schematic results must be regenerated before formal use. Section 5.8 uses the current generated BIAS CSVs.

### 5.1 Operating Point

| Metric | G2 | G16 |
| --- | ---: | ---: |
| Total supply current | 8.8568 mA | 8.8568 mA |
| Total power | 29.2275 mW | 29.2276 mW |
| Bias-current diagnostic | 40 uA | 40 uA |
| VOUTP | 1.66178 V | 1.60522 V |
| VOUTN | 1.63817 V | 1.69473 V |
| Output common mode | 1.64998 V | 1.64998 V |
| Output differential DC | 23.62 mV | -89.52 mV |

### 5.2 Differential Gain

| Frequency and method | G2 gain error | G16 gain error |
| --- | ---: | ---: |
| 0.05 Hz AC | -11.41% | -16.04% |
| 0.05 Hz transient | -99.68% | -99.70% |
| 60 Hz AC | -6.87% | -11.74% |
| 60 Hz transient | -7.14% | -11.97% |
| 150 Hz AC | -11.21% | -15.85% |
| 150 Hz transient | -11.34% | -15.95% |

At 60 Hz, the transient fitted gains are 445.75 V/V for G2 and 3380.39 V/V for G16. AC and transient results agree reasonably at 60 Hz and 150 Hz, but not at 0.05 Hz.

The PATH differential-response figure is regenerated as `PATH/Plots/NOM.diff_response.png`.

### 5.3 AC Band Edges and Noise

| Metric | G2 | G16 |
| --- | ---: | ---: |
| High-pass -1 dB corner | 0.03477 Hz | 0.03477 Hz |
| High-pass -3 dB corner | 0.01779 Hz | 0.01779 Hz |
| Low-pass -1 dB corner | 220.15 Hz | 220.15 Hz |
| Low-pass -3 dB corner | 430.16 Hz | 430.16 Hz |
| Input-referred noise, 0.05-150 Hz | 3.2453 uVrms | 3.2452 uVrms |

For G16, the current full summary reports 5.426 uVrms from 0.01 Hz to 1 kHz and 34.72 dB input-referred SNR for a 0.5 mVpp input over the 0.05-150 Hz noise band.

### 5.4 AC CMRR and PSRR

| Metric | G2 | G16 |
| --- | ---: | ---: |
| CMRR at 0.05 Hz | 95.95 dB | 105.49 dB |
| CMRR at 60 Hz | 147.64 dB | 153.45 dB |
| CMRR at 150 Hz | 148.04 dB | 154.09 dB |
| CMRR at 1 kHz | 148.10 dB | 154.10 dB |
| PSRR+ at 60 Hz | 110.20 dB | 110.52 dB |
| PSRR+ at 150 Hz | 109.80 dB | 110.11 dB |
| PSRR+ at 1 kHz | 102.32 dB | 102.59 dB |
| PSRR- at 60 Hz | 110.20 dB | 110.52 dB |
| PSRR- at 150 Hz | 109.80 dB | 110.11 dB |
| PSRR- at 1 kHz | 102.32 dB | 102.59 dB |

These are small-signal AC results. Transient CMRR and PSRR values use a different sine-fit calculation and appear separately in the full summary.

### 5.5 Offset and Reset Startup

Across the current VCM-offset and differential-offset sweeps, the analyzer reports:

- Maximum output-common-mode error after reset: approximately 0.0487 mV.
- Maximum absolute differential output: approximately 1.114 V.
- No detected output clipping in the analyzed windows.
- Zero-offset fitted gain: 3374.82 V/V for the 0.5 mVpp/G16 case and 445.63 V/V for the 5 mVpp/G2 case.

The G16 offset-test gain is about 12.1% below its nominal 3840 V/V target, outside the analyzer's current +/-10% usability criterion. This is a gain-accuracy issue, not a clipping failure.

With reset enabled under the 300 mV differential-DC startup test, the current summary reports:

| Startup metric | Result |
| --- | ---: |
| Differential-offset removal | 99.924% |
| Improvement versus no reset | 62.42 dB |
| Differential settling to +/-10 mV after reset | 0.880 ms |
| Final output-CM error | 0.0486 mV |
| Post-reset differential ripple | 0.3868 mVpp |
| Output stuck near a rail | No |
| Analyzer startup pass | Yes |

### 5.6 RLD

| RLD metric at 60 Hz | Result |
| --- | ---: |
| Input-common-mode suppression | 20.25 dB |
| Differential-output improvement | 20.47 dB |
| RLD output minimum | 1.5669 V |
| RLD output maximum | 1.7327 V |
| RLD peak current | 0.0913 uA |

### 5.7 THD and SNR

| Case | THD | SNR |
| --- | ---: | ---: |
| 0.5 mVpp, G16, 60 Hz | 0.09545% | 34.24 dB |
| 5 mVpp, G2, 60 Hz | 0.08572% | 54.48 dB |
| 0.5 mVpp, G16, 150 Hz | 0.10015% | Not included in compact report |
| 5 mVpp, G2, 150 Hz | 0.08243% | Not included in compact report |

The PATH harmonic figure is regenerated as `PATH/Plots/NOM.thd.png`.

### 5.8 BIAS and Selector Characterization

The normal-process columns below use the 27 C, 3.3 V transient for each process. Values come from `BIAS_table_report.csv`.

| Metric | NOM | FF | SS | FS | SF |
| --- | ---: | ---: | ---: | ---: | ---: |
| IBIAS (uA) | 39.997 | 45.168 | 35.799 | 40.621 | 39.350 |
| IBIAS error (%) | -0.007499 | 12.920 | -10.503 | 1.553 | -1.626 |
| BP (V) | 1.643 | 1.748 | 1.533 | 1.523 | 1.763 |
| VREF (V) | 1.650 | 1.650 | 1.650 | 1.650 | 1.650 |
| BIAS+SEL current (uA) | 83.192 | 94.351 | 74.243 | 84.477 | 81.858 |
| BIAS+SEL power (uW) | 274.532 | 311.359 | 245.001 | 278.773 | 270.131 |
| Startup time (us) | 807.362 | 777.960 | 839.332 | 838.091 | 804.619 |

The environmental columns in the same compact table use the NOM process:

| Metric | VL | VH | TL | TH |
| --- | ---: | ---: | ---: | ---: |
| Temperature (C) | 27 | 27 | -40 | 125 |
| VDD (V) | 3.0 | 3.6 | 3.3 | 3.3 |
| IBIAS (uA) | 39.393 | 40.423 | 35.353 | 43.171 |
| IBIAS error (%) | -1.517 | 1.056 | -11.619 | 7.926 |
| Startup time (us) | 882.469 | 743.647 | 896.673 | 807.833 |

Across the complete 35-run startup matrix, the fastest reported startup is 716.718 us at FF/VH and the worst is 1180.295 us at SS/TLVL (-40 C, 3.0 V). No startup failures were detected (`0 / 35`).

![NOM BIAS startup current](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP.png)

The global 2-D extrema are:

| Metric | Value | Process | Temperature | VDD |
| --- | ---: | --- | ---: | ---: |
| IBIAS minimum | 31.054 uA | SS | -40 C | 3.0 V |
| IBIAS maximum | 49.441 uA | FF | 125 C | 3.6 V |
| Worst absolute IBIAS error | 23.603% | FF | 125 C | 3.6 V |
| BP minimum | 1.138 V | FS | 125 C | 3.0 V |
| BP maximum | 2.146 V | SF | -40 C | 3.6 V |
| Maximum absolute VREF error | 6.155 uV | SS | -40 C | 3.6 V |
| Maximum absolute mirror error | 0.1490% | FS | 125 C | 3.0 V |
| Minimum MST margin | 0.7415 V | FF | 125 C | 3.6 V |
| Maximum BIAS+SEL current | 103.971 uA | FF | 125 C | 3.6 V |
| Maximum BIAS+SEL power | 374.297 uW | FF | 125 C | 3.6 V |

![NOM BIAS current-error heat map](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_2D.png)

Reference-quality summaries derived from the complete temperature and supply slices are:

| Metric | NOM | FF | SS | FS | SF |
| --- | ---: | ---: | ---: | ---: | ---: |
| Temperature coefficient (ppm/C) | 1184.627 | 1223.228 | 1150.065 | 1177.302 | 1193.652 |
| Temperature variation (%) | 19.546 | 20.183 | 18.976 | 19.425 | 19.695 |
| Line regulation (%/V) | 4.290 | 3.889 | 5.185 | 4.598 | 4.361 |
| Supply variation (%) | 2.574 | 2.333 | 3.111 | 2.759 | 2.616 |

The maximum selector errors over all 35 transient runs are 12.493 nV for BP internal selection, 25.466 nV for BP external selection, 18.750 nV for VREF internal selection, and 10.951 nV for VREF external selection. These nanovolt values reflect ideal pre-layout schematic switching and may be close to numerical floors.

![NOM BIAS internal/external selection](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_SEL.png)

## 6. Interpretation and Limitations

### 6.1 Low-Frequency AC/Transient Mismatch

At 0.05 Hz, ordinary AC analysis predicts gain errors of -11.41% for G2 and -16.04% for G16, while the transient sine fit reports about -99.7% for both. The 0.1 Hz transient cases are also strongly attenuated, whereas the 0.5 Hz cases return close to the 60 Hz gain.

The PATH is periodically switched by a 500 Hz clock. A conventional AC sweep linearizes one operating state and does not, in general, provide the frequency response of a linear periodically time-varying circuit. The low-frequency discrepancy may also be sensitive to settling history, simulator tolerances, source amplitude, exported resolution, and the selected final-cycle window.

Required follow-up:

1. Re-run the low-frequency transient cases with tighter tolerances and a stimulus comfortably above `vntol`.
2. Confirm true periodic steady state before selecting the analysis window.
3. Compare multiple final cycles instead of relying on a single-cycle result where practical.
4. Use PSS/PAC or an equivalent sampled-system analysis if the simulator flow supports it.
5. Do not claim the ordinary AC or low-frequency transient number as final until the two methods are reconciled.

### 6.2 Rejection Accuracy

CMRR and PSRR from the compact report are AC values. Transient markers use fitted rejection based on the transient differential gain. Differences between the markers and AC curve therefore do not mean that the marker is plotted incorrectly; they represent different calculations on a periodically switched system. Very large nominal rejection values are also sensitive to numerical floors and ideal schematic symmetry. Mismatch and Monte Carlo simulations are required before treating them as realistic production values.

### 6.3 THD Accuracy

The THD analyzer avoids independent one-tone fits. It solves H1-H10 simultaneously and includes non-overlapping clock harmonics as nuisance tones. This is important because signal harmonics can lie near the 500 Hz switched-capacitor clock. The reported THD remains a finite-record, nominal schematic result and should be repeated across process, temperature, input amplitude, clock timing, and extracted parasitics.

### 6.4 BIAS Data and Coverage Limitations

The BIAS results are deterministic pre-layout schematic corners without mismatch, Monte Carlo, or extracted parasitics. The 2-D DC sweeps establish static temperature/supply surfaces but do not prove startup or selection dynamics between the seven discrete transient environments, and all current startup runs use the same 100 us to 1.1 ms VDD ramp.

The current NOM transient exports repeat scalar `IRS`, `IMST`, `VGS_MST`, and `VTH_MST` values across the time rows. Those final operating-point values remain usable in the compact table, but the NOM IMST startup waveform is unavailable. The current `NOM.dc2d.txt` is also the legacy 12-column export. Its current, voltage, power, temperature-coefficient, and line-regulation results are usable, but NOM mirror-error, IMST, and MST-margin sweep extrema require regeneration. Consequently, the reported global mirror-error and MST-margin extrema currently search FF/SS/FS/SF data but cannot prove that NOM is not worse.

No mirror drain-voltage compliance sweep is included. The reported mirror error applies only to the present testbench operating points and DC grids. The range-normalized TC and line-regulation metrics can also hide curvature or local slope changes.

### 6.5 Verification Coverage

The integrated PATH flow remains nominal-only. The dedicated BIAS flow includes process, voltage, and temperature characterization, but this is not complete-chip PVT sign-off. The project still does not establish:

- Integrated PATH and complete-chip process, voltage, and temperature margins.
- Device mismatch or Monte Carlo yield.
- Extracted bandwidth, noise, distortion, or settling.
- ESD, pad, package, electrode, or board parasitics beyond the present test models.
- ADC loading and end-to-end ECG acquisition performance.
- Measured silicon performance.

## 7. Next Steps

| Priority | Item | Completion criterion |
| --- | --- | --- |
| P0 | Refresh NOM BIAS exports | Seven NOM transients contain true IRS/IMST/VGS/VTH vectors and `NOM.dc2d.txt` uses the current 14-column schema |
| P0 | Resolve 0.05 Hz and 0.1 Hz transient gain | Stable repeated result with documented steady-state method and agreement with an appropriate periodically switched analysis |
| P0 | Confirm gain accuracy | Explain or correct the approximately -7% G2 and -12% G16 error at 60 Hz |
| P1 | Add integrated PATH PVT coverage | Automated PATH summaries for process, supply, and temperature corners |
| P1 | Add mismatch/Monte Carlo | Statistical offset, CMRR, PSRR, gain, and yield results |
| P1 | Recheck THD/SNR | Sweep amplitude and clock timing; verify noise bandwidth and clock-sideband handling |
| P1 | Complete layout | DRC/LVS-clean PATH layout with extracted simulations |
| P2 | Integrate the SAR ADC | End-to-end analog-plus-ADC simulations against the system specification |
| P2 | Develop PCB and measurement plan | Test points, supplies, interfaces, equipment, and acceptance criteria documented |

## 8. Reproducibility and Source of Truth

Run the MATLAB analyzer from the repository root with:

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','PATH','PATH_Analyze.m'))"
```

Run the function-based BIAS analyzer with:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
```

Calculation sources and generated artifacts are:

- `PATH_Analyze.m`: calculation and plotting rules.
- `PATH_TB_AC.sch`, `PATH_TB_NOISE.sch`, and `PATH_TB_TRAN.sch`: applied conditions and simulation schedules.
- `PATH_summary.csv`: generated complete result set, including all transient cases; currently requires regeneration.
- `PATH_table_report.csv`: generated G2/G16/RLD/THD report; currently requires regeneration.
- The 12 PATH figures generated by `PATH_Analyze.m`; currently requires regeneration.
- `BIAS_Analyze.m`: BIAS calculation, table, CSV, and plotting rules.
- `BIAS_table_report.csv`: process and NOM environmental operating-point/startup table.
- `BIAS_startup_report.csv` and `BIAS_startup_summary.csv`: all 35 startup values and the worst-case/failure summary.
- `BIAS_sel_report.csv`: global BP/VREF internal/external selection errors.
- `BIAS_dc2d_report.csv` and `BIAS_global_worst_case.csv`: per-process surfaces and global extrema with locations.
- `BIAS_reference_report.csv`: temperature and supply variation summaries.
- The six NOM figures directly generated by the current `BIAS_Analyze.m` in `BIAS/Plots/`.

Raw ngspice `*.txt` exports remain local and are ignored by Git. Re-running MATLAB without regenerating the raw data only re-analyzes the local simulation state; therefore, the schematics, testbench revision, CSV timestamp, and plot timestamp should be recorded together for formal design reviews.

## 9. Project Status Outside the IC Path

| Area | Current status |
| --- | --- |
| PCB schematic | Not started |
| PCB layout | Not started |
| PCB simulation | Not started |
| Laboratory test setup | Not started |
| Measurement results | Not available |

These sections should be expanded after the IC layout and ADC interface are sufficiently stable to define the board and measurement requirements.
