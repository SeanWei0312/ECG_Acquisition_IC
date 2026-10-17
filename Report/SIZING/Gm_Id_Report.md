# $g_m/I_D$ Characterization Report

[← System-level project report](../../Project_Report.md)

## Purpose

Updated 2026-10-17. The characterization files are under `Measurement_Results/IC_Simulation/SIZING/Gm_Id`, separately from block-verification results.

The NMOS and PMOS characterization utilities provide the lookup data used to size the bias network and OTA devices. They report transconductance efficiency, current density, transition frequency, and intrinsic gain for the GlobalFoundries 180 nm MCU devices.

| Device | Analyzer | Status |
| :--- | :--- | :---: |
| NMOS | [`NMOS_Gm_Id.m`](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/NMOS_Gm_Id.m) | Available |
| PMOS | [`PMOS_Gm_Id.m`](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/PMOS_Gm_Id.m) | Available |

## How the data supports sizing

1. Select channel length and representative drain/body biases for the intended device role.
2. Obtain required transconductance from circuit gain, noise, or bandwidth constraints.
3. Select transconductance efficiency from the characterized curves and calculate current as $I_D=g_m/(g_m/I_D)$.
4. Read the matching current density $J_D=I_D/W$ and calculate $W=I_D/J_D$.
5. Check speed, intrinsic gain, capacitance, and headroom in the complete circuit. Iterate rather than treating a single lookup point as signoff.

The [SEOTA](../ANALOG_BLOCKS/SEOTA_Report.md) and [FDOTA](../ANALOG_BLOCKS/FDOTA_Report.md) reports retain the detailed sizing calculations and trade-offs. Their current verification sections, not the lookup plots alone, establish exported block performance.

## NMOS plots

The current-density curves determine width at the selected bias and length. The efficiency, intrinsic-gain, and speed curves show the competing choices; use the same characterization conditions when comparing them.

![NMOS current density versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_gmid.png)

![NMOS current density versus VGS](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_vgs.png)

![NMOS gm/Id-times-fT versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_gmid_times_ft_vs_gmid.png)

![NMOS gm/Id versus VGS](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_gmid_vs_vgs.png)

![NMOS intrinsic gain in dB versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_db_vs_gmid.png)

![NMOS intrinsic gain versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_vs_gmid.png)

## PMOS plots

The PMOS plots use the corresponding source-referenced voltage convention. Read current density and efficiency from the same device-length curve before estimating width.

![PMOS current density versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_gmid.png)

![PMOS current density versus VSG](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_vsg.png)

![PMOS gm/Id-times-fT versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_gmid_times_ft_vs_gmid.png)

![PMOS gm/Id versus VSG](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_gmid_vs_vsg.png)

![PMOS intrinsic gain in dB versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_db_vs_gmid.png)

![PMOS intrinsic gain versus gm/Id](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_vs_gmid.png)

## Scope limitation

These plots are design-characterization aids rather than block-level pass/fail results. Device models and extracted-layout effects must be rechecked at the final physical-design stage.
