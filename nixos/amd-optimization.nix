{ pkgs, ... }:

{
  boot.kernelParams = [
    # # --- CPU & System ---
    # "amd_pstate=active" # AMD P-State driver for optimal power scheduling
    # "iommu=pt" # IOMMU passthrough for low-latency hardware mapping

    # # --- GPU: Aggressive Workarounds for Strix Point (gfx1150) ---
    # "amdgpu.dcdebugmask=0x10" # Fixes potential terminal rendering lags & flickering
    # "amdgpu.runpm=0" # Disables aggressive runtime power management to prevent deep-state drops
    # "amdgpu.mes=0" # CRITICAL: Disables Micro Engine Scheduler to block ML ring-buffer timeout hangs
    # "amdgpu.gpu_recovery=1" # Enables automated recovery loops if the driver stalls during a batch
    # "amdgpu.lockup_timeout=10000" # Generous 10-second timeout allocation for heavy token execution
    # "amdgpu.noretry=0"

    # # VPE queue suspension workaround for Strix Point stability
    # "amdgpu.ip_block_mask=0x7FF"
  ];

  # Guarantee the open-source graphics stack triggers early in the boot sequence
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        libva-utils
        libva-vdpau-driver
        libvdpau-va-gl
        # Crucial layer: Allows tracking libraries to latch onto the ROCm driver interface
        rocmPackages.clr.icd
      ];
    };
  };

  # Hardware rules to bind the stability parameters to your Radeon 890M
  services.udev.extraRules = ''
    # Match the explicit Radeon 890M Device ID (150e) to maintain power consistency
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x150e", \
      ATTR{power/control}="on"
  '';

  # High-throughput power profiling via TLP
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # Maximize power to the Compute Units when hooked to wall power
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";

      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "default";

      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # MATCHES YOUR HARDWARE: Point denylist strictly to the correct Strix Point GPU PCI address
      RUNTIME_PM_DENYLIST = "c1:00.0";

      USB_AUTOSUSPEND = 1;
      RESTORE_DEVICE_STATE_ON_STARTUP = 1;
    };
  };
}
