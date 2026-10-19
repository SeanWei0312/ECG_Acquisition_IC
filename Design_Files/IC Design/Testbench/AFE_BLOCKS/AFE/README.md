# Complete AFE verification fixture

The DUT includes BIAS, MIRROR, RLD, INA, LPF, PGA, FDBUF and the four signal selectors. All selectors use the internal path for the full performance suite. Each external pair now has an independent differential source centered on REF; its AC/transient excitation is zero during normal performance tests. The reference is an ideal VDD/2 source. Gain and selector-control voltages track VDD. The connected body/electrode/RLD fixture follows INA_RLD, including zero-default electrode-offset sources, disabled 1e15-ohm electrode bypasses, and a zero-volt loop probe. These support elements do not add standalone RLD characterization to the AFE measurement plan.

## Conditions

- PVT: NOM/FF/SS/FS/SF, each at 3.0/3.3/3.6 V and -40/27/125 C: 45 corners, four gains per corner.
- MC: MM/GL/FULL, 200 samples each. One `mc_source` per sample, then four gains without reload or reset. No separate random realization is drawn for a gain setting.
- PGA G2/G4/G8/G16: total target gains 480/960/1920/3840 V/V.
- Electrode impedances: 51 kohm in parallel with 47 nF per signal electrode and RLD electrode. Coupling and body-return capacitances: 100 pF each. RLD series resistance: 1 Mohm.
- Load: 60 pF from each final output to AGND; not a 60 pF differential capacitor.
- No on-chip or off-chip DCB, electrode DC offset, ADC, or sampling model is included. Actual DUT mismatch offset is not canceled.

## Measurements

Every gain configuration exports operating point, differential AC, CMRR AC, PSRR+ AC, spectral noise, and the final-output transient. Frequency responses are complex pairs, not precomputed dB, so gain/rejection conventions remain explicit in post-processing. Integrate squared noise density over 0.05-150 Hz in MATLAB, inserting interpolated band endpoints from the 0.01 Hz-1 kHz sweep. Do not use the simulator's non-finite integrated-noise vectors as valid measurements.

The differential AC sweep is 0.01 Hz to 1 MHz. Use the 10 Hz gain as reference for gain error, loss at 150 Hz and the downward -1 dB crossing. There is no high-pass requirement in this DC-coupled fixture. CMRR is normalized to the measured input common mode; PSRR+ is normalized to the measured AVDD-AGND perturbation. The independent REF source does not track supply ripple. Noise includes the electrode resistors and is integrated over 0.05-150 Hz.

The 10 Hz differential sine has source peak amplitude `1/(240*PGA_gain)` V, targeting 1 V peak at the final differential output. Simulate to 0.6 s and retain 0.2-0.6 s. The uniform interval is 97.65625 us: four cycles and 4096 samples after discarding the repeated final endpoint. Compute a rectangular-window coherent FFT from those 4096 samples; SFDR is the fundamental relative to the largest non-DC, non-fundamental spectral line below Nyquist, not only harmonic THD. Check stationarity and settling before accepting that FFT. Use measured fundamental RMS power and integrated output-noise power for analog SNR, not FFT numerical residue as noise. Check both single-ended outputs against their rails and verify fundamental compression when assessing clipping.

RLD ON/OFF tests run at G2 in every corner/sample. A 1 pH series inductor enables the return path; 1 TH isolates it in AC while preserving the DC operating point. Compare input common-mode response at 60 and 150 Hz. The AC source is 1 V; multiply its response by 20 Vrms to obtain the requested source-referenced residual. The 60 Hz transient uses 20 Vrms injection through the coupling capacitor and retains 0.2-0.4 s. Use the difference between ON and OFF rejection to calculate improvement. These are interference-injection simulations, not human-use electrical-safety verification.

## Export schema

Each numeric text file has one scale column, followed by the vectors below. PVT filenames identify process, gain and environment; MC replaces environment with `mc1` through `mc200`. Existing files are overwritten only when their analysis completes; file presence alone does not prove a complete new run.

| Suffix | Scale | Remaining columns |
|---|---|---|
| `op` | dummy index | VDD, IDD, power, output CM error, output CM, output differential DC, input CM |
| `diff_ac` | Hz | input real/imaginary, output real/imaginary |
| `cmrr_ac` | Hz | input CM real/imaginary, output differential real/imaginary |
| `psrrp_ac` | Hz | supply real/imaginary, output differential real/imaginary |
| `noise` | Hz | output V/sqrt(Hz), input-referred V/sqrt(Hz) |
| `signal_tran` | seconds | source differential, OUTP, OUTN, REF, AVDD (V) |
| `rld_on_ac`, `rld_off_ac` | Hz | input CM real/imaginary, body real/imaginary |
| `rld_on_tran`, `rld_off_tran` | seconds | body, input CM, output differential (V) |

## Selector integration

At G2, each signal selector is tested in INT and EXT with the other three held INT. Each configuration has a DC operating point, a 10 Hz main-input transfer, and a 25 Hz external-input transfer. This adds eight lightweight configurations per PVT corner or MC sample, without repeating noise or FFT analyses and without drawing another MC realization. BIAS remains INT; no removed DCB path is exercised.

Expected main-path gain is 480 V/V. Expected external-path gains for INA/LPF/PGA/FDBUF selection are 2/2/1/1 V/V, respectively. An external source replaces a stage output; it does not emulate the bypassed upstream circuitry. Functional source peaks are 0.2/480 V at the main input and 0.3/(external target gain) V at the active external pair. The two AC responses can be superposed to distinguish 10 Hz main signal from 25 Hz external signal.

For each `selector_<path>_<int|ext>_<environment>` prefix, `.op.txt` contains dummy scale, VDD, REF, OUTP DC, OUTN DC, main source peak and external source peak. `.main_ac.txt` contains 10 Hz and complex OUTP/OUTN response to a unit main input. `.ext_ac.txt` contains 25 Hz and complex OUTP/OUTN response to a unit external input. These sources are driven separately, not simultaneously with indistinguishable AC phases.

`AFE_Analyze.m` includes local selector-analysis functions that print comparison/worst-case and MM/GL/FULL selector tables and return pass masks for combination with main-AFE results. It uses the proposed AFE gain tolerance of +/-3%, checks that the selected path dominates, and reports normalized leakage without an additional isolation specification. Its output headroom check uses conservative summed single-ended AC excursions around the measured DC operating point. This is not a nonlinear clipping test or glitch-free switching verification. The routing figure is explicitly labeled as an AC reconstruction, not a simulated transient. DCB selection is N/A.

The schematics export measurements, not PASS declarations. Missing/invalid analyses cannot be counted as passes. `AFE_Analyze.m` is the single MATLAB entry point, with selector reporting implemented as local functions. Its legacy performance reader still uses an older nominal-only export layout: when the new performance format is present (or legacy data are absent), the entry point stops after selector reporting with an explicit performance-reader warning rather than misreading the new files. Selector pass masks must be ANDed with the corresponding performance masks once that reader is migrated. No complete AFE yield, full-PVT or 600-sample MC result is implied by creating these testbenches.
