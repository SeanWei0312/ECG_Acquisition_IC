# $g_m/I_D$ Characterization Report

[← System-level project report](../../Project_Report.md)

## Purpose

The NMOS and PMOS characterization utilities provide the lookup data used to size the bias network and OTA devices. They report transconductance efficiency, current density, transition frequency, and intrinsic gain for the GlobalFoundries 180 nm MCU devices.

| Device | Analyzer | Status |
| :--- | :--- | :---: |
| NMOS | [`NMOS_Gm_Id.m`](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/NMOS_Gm_Id.m) | Available |
| PMOS | [`PMOS_Gm_Id.m`](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/PMOS_Gm_Id.m) | Available |

## NMOS plots

![NMOS current density versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_gmid.png)

![NMOS current density versus VGS](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_vgs.png)

![NMOS gm/Id-times-fT versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_gmid_times_ft_vs_gmid.png)

![NMOS gm/Id versus VGS](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_gmid_vs_vgs.png)

![NMOS intrinsic gain in dB versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_db_vs_gmid.png)

![NMOS intrinsic gain versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_vs_gmid.png)

## PMOS plots

![PMOS current density versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_gmid.png)

![PMOS current density versus VSG](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_vsg.png)

![PMOS gm/Id-times-fT versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_gmid_times_ft_vs_gmid.png)

![PMOS gm/Id versus VSG](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_gmid_vs_vsg.png)

![PMOS intrinsic gain in dB versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_db_vs_gmid.png)

![PMOS intrinsic gain versus gm/Id](../../Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_vs_gmid.png)

## Scope limitation

These plots are design-characterization aids rather than block-level pass/fail results. Device models and extracted-layout effects must be rechecked at the final physical-design stage.
