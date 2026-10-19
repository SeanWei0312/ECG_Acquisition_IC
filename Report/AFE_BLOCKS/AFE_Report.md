# Integrated AFE Design and Verification Report

[← System-level project report](../../Project_Report.md)

## Architecture

![Integrated analog front end](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

The integrated analog signal path is:

```text
Electrode input → INA + RLD → LPF → PGA → FDBUF
```

| Stage | Nominal behavior | Detailed report |
| :--- | :---: | :--- |
| INA + RLD | 240 V/V plus input common-mode feedback | [INA + RLD report](INA_RLD_Report.md) |
| LPF | Unity gain; −1 dB frequency ≥150 Hz | [LPF report](LPF_Report.md) |
| PGA | 2/4/8/16 V/V | [PGA report](PGA_Report.md) |
| FDBUF | Unity-gain differential output driver | [FDBUF report](FDBUF_Report.md) |

The programmed signal-path gain is nominally 480, 960, 1920, or 3840 V/V at the FDBUF output.

## System design sequence

The integrated AFE is assembled from verified amplifier and signal-conditioning blocks. The following calculations define the architecture and expected signal levels; they are not measured full-chain results.

### 1. Allocate gain before selecting programmable range

The fixed input gain is 240 V/V. Keep the LPF and output buffer at unity gain, then place the selectable gain after the LPF:

$$
G_{\mathrm{AFE}}=G_{\mathrm{INA}}G_{\mathrm{LPF}}G_{\mathrm{PGA}}G_{\mathrm{BUF}}
=240(1)\{2,4,8,16\}(1).
$$

| PGA gain | Planned AFE gain | Gain, dB | Electrode-input magnitude for 2.4-V differential output |
| :--- | :--- | :--- | :--- |
| 2 | 480 V/V | 53.62 | 5.000 mV |
| 4 | 960 V/V | 59.65 | 2.500 mV |
| 8 | 1920 V/V | 65.67 | 1.250 mV |
| 16 | 3840 V/V | 71.69 | 0.625 mV |

The input column follows \(V_{\mathrm{IN}}=2.4/G_{\mathrm{AFE}}\). It is a gain-plan limit, not a measured integrated usable range. Higher gain improves output utilization for small signals but clips larger electrode signals sooner.

### 2. Put low-noise gain first and filtering before programmable gain

The INA's large initial gain reduces later stages' noise when referred to the electrode input. For uncorrelated stage-added noise,

$$
e_{\mathrm{RTI}}^2\approx e_{\mathrm{INA}}^2+
\frac{e_{\mathrm{LPF}}^2}{240^2}+
\frac{e_{\mathrm{PGA}}^2}{240^2}+
\frac{e_{\mathrm{BUF}}^2}{(240G_{\mathrm{PGA}})^2}.
$$

Each contribution must use its own frequency-dependent transfer and the same integration band. The displayed equation is a flat-passband approximation, not the complete integrated noise calculation.

For example, the LPF's nominal 6.173 µVrms becomes approximately 25.72 nVrms after division by the preceding gain of 240. The INA's nominal 2.677 µVrms remains the dominant contribution in that comparison.

The LPF follows the input gain so its multi-megaohm network does not directly set electrode input impedance. Placing it before PGA prevents programmable gain from amplifying as much out-of-band content. It does not eliminate the need to test overload recovery.

### 3. Keep differential gain and common-mode control separate

Use \(V_{\mathrm{REF}}=V_{\mathrm{DD}}/2\) as the nominal output-common-mode target. Differential FDOTA stages regulate their own output common mode; RLD separately reduces electrode/body common-mode interference.

This separation does not make the loops independent. The body model, source mismatch, finite amplifier output impedance, and selector states must be included when testing the integrated RLD loop.

### 4. Distribute bias with matched unit mirrors

BIAS establishes approximately 40 µA. MIRROR uses equal 16/4-µm PMOS units to provide reference currents to the reused amplifier blocks.

The unit geometry is chosen for matching and reduced drain-voltage sensitivity. Total AFE supply current is not 40 µA times the number of reference pins: each amplifier scales its reference internally and draws output-stage current.

Do not add block-testbench currents as a final power estimate. Their bias generators and fixtures can overlap; the integrated supply source must measure the actual system current.

### 5. Add selectors for internal-versus-external signal testing

MUXD selects internal stage outputs or externally driven differential signals. MUX selects the internal or external bias voltage. These paths support testing one stage without requiring the complete upstream chain.

The shared transmission gate uses NMOS W/L = 25/0.28 µm and PMOS W/L = 50/0.28 µm. Short L and wide W reduce on-resistance; larger gate area increases charge injection and feedthrough.

The inverter uses NMOS W/L = 1/0.5 µm and PMOS W/L = 2/0.5 µm. Its longer channel and smaller width reduce control loading relative to the analog switches, at the cost of finite gate-drive delay.

These are inherited cell choices, not independently optimized widths for every selector. Correct static selection does not establish glitch-free gain switching or break-before-make behavior.

#### Selector integration at G2

The complete internal chain retains the four-gain performance suite. A separate, lightweight routing group drives each signal selector in INT and EXT while leaving the other selectors INT, in every PVT corner and MM/GL/FULL sample. The same statistical realization is retained across gain settings and routing configurations.

| Selected external path | Downstream path | Expected gain at G2 |
| :--- | :--- | :---: |
| INA EXT | LPF → PGA → FDBUF | 2 V/V |
| LPF EXT | PGA → FDBUF | 2 V/V |
| PGA EXT | FDBUF | 1 V/V |
| FDBUF EXT | Final selector/output load | 1 V/V |

Each EXT pair has an independent source centered on REF rather than a permanent short to REF. A 10 Hz main-input response and 25 Hz external-input response identify the active and rejected paths. At nominal target gain their functional output peaks are 0.2 V and 0.3 V, respectively. The selected-path gain uses the proposed +/-3% AFE tolerance. Leakage is reported relative to the same source's selected-path transfer; no extra isolation limit is invented.

The DC operating point and single-ended AC excursions provide a conservative headroom screen, not proof of nonlinear clipping or safe switching transients. The nominal routing figure is a labeled linear AC reconstruction. These ideal external sources verify routing only, not an unmodeled external amplifier or filter. No DCB routing result is claimed.

Very small schematic AC leakage values must not be interpreted as measured isolation: parasitic coupling, switching feedthrough and layout effects require transient and extracted-circuit checks.

| Selector verification | Full PVT | MM / GL / FULL MC |
| :--- | :---: | :---: |
| INA INT/EXT | Pending | Pending |
| LPF INT/EXT | Pending | Pending |
| PGA INT/EXT | Pending | Pending |
| FDBUF INT/EXT | Pending | Pending |
| DCB selection | N/A | N/A |

The [AFE analyzer](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/AFE/AFE_Analyze.m) includes selector reporting and counts missing or malformed exports as incomplete coverage, never as passing samples. Selector pass masks must be combined with the main performance pass masks before declaring complete AFE yield. Pilot runs are not full-PVT or 200-sample signoff evidence.

### 6. Verify the load envelope at the delivered output

FDBUF drives 40–100 pF per side, with 60 pF nominal. The preceding PGA should see the buffer input network rather than the full output capacitance.

The integrated output test must include the selected MUXD path. A correct internal buffer waveform does not prove that the delivered OUT waveform has the same settling and distortion.

### 7. Close the architecture with full-chain simulation

The component-level sizing rationale remains in the BIAS, SEOTA, FDOTA, INA/RLD, LPF, PGA, and FDBUF reports. Their dimensions are inherited unchanged at integration.

The next comparison is planned gain and noise versus integrated results at every gain setting, supply, temperature, and intended load. Until those exports exist, the tables above describe design intent only.

## Verification status

Updated 2026-10-19. The current AFE measurement folder has no generated full-chain signoff tables or plots. Selector pilots and analyzer tests are kept separate from verification exports. This is a coverage statement, not a failed circuit result.

| Item | Status |
| :--- | :---: |
| Top-level schematic | Available |
| PVT/MC testbenches | Available, including lightweight selector checks |
| MATLAB analyzer | Selector reporting implemented; new performance-reader migration pending |
| Full-chain PVT results | Pending |
| Full-chain Monte Carlo | Pending |
| Generated tables and plots | Pending |
| Integrated output-load settling | Pending |

The analyzer is [`AFE_Analyze.m`](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/AFE/AFE_Analyze.m). Its existence does not establish that the integrated simulations have completed.

BIAS and MIRROR now reside under `POWER_BLOCKS`. FDBUF has a complete block analyzer and exported PVT/MC reports for static 40/60/80/100-pF loads. ADC development is outside this report's scope.

## Required system-level measurements

- Programmable differential gain and gain error for every PGA code.
- Passband response, −1 dB frequency, and overall bandwidth.
- Integrated input-referred noise over 0.05–150 Hz.
- CMRR and PSRR at 60 Hz and 150 Hz.
- Output common mode, output swing, and transient settling.
- RLD stability and common-mode suppression in the integrated loop.
- Selector behavior and gain-code switching.
- Settling under the intended integrated output load.

## Design files

- [AFE schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.sch)
- [AFE schematic image](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

Integrated verification remains pending. Use the individual block reports for current schematic measurements and specifications.
