{ OpenVR SDK 1.14.15 }

unit openvr_api;

{$mode delphi}
{$macro on}
{$modeswitch advancedrecords}
{$ifdef windows}
  {$define OVRCALL:=stdcall}
  {$define OVRLIB:='openvr_api.dll'}
{$else}
  {$define OVRCALL:=cdecl}
  {$define OVRLIB:='openvr_api.so'}
{$endif}

interface

uses ctypes, dynlibs;

type
  EVREye = (
    Eye_Left = 0,
    Eye_Right = 1
  );

  ETextureType = (
    TextureType_Invalid = -1,
    TextureType_DirectX = 0,
    TextureType_OpenGL = 1,
    TextureType_Vulkan = 2,
    TextureType_IOSurface = 3,
    TextureType_DirectX12 = 4,
    TextureType_DXGISharedHandle = 5,
    TextureType_Metal = 6
  );

  EColorSpace = (
    ColorSpace_Auto = 0,
    ColorSpace_Gamma = 1,
    ColorSpace_Linear = 2
  );

  ETrackingResult = (
    TrackingResult_Uninitialized = 1,
    TrackingResult_Calibrating_InProgress = 100,
    TrackingResult_Calibrating_OutOfRange = 101,
    TrackingResult_Running_OK = 200,
    TrackingResult_Running_OutOfRange = 201,
    TrackingResult_Fallback_RotationOnly = 300
  );

  ETrackedDeviceClass = (
    TrackedDeviceClass_Invalid = 0,
    TrackedDeviceClass_HMD = 1,
    TrackedDeviceClass_Controller = 2,
    TrackedDeviceClass_GenericTracker = 3,
    TrackedDeviceClass_TrackingReference = 4,
    TrackedDeviceClass_DisplayRedirect = 5,
    TrackedDeviceClass_Max = 6
  );

  ETrackedControllerRole = (
    TrackedControllerRole_Invalid = 0,
    TrackedControllerRole_LeftHand = 1,
    TrackedControllerRole_RightHand = 2,
    TrackedControllerRole_OptOut = 3,
    TrackedControllerRole_Treadmill = 4,
    TrackedControllerRole_Stylus = 5,
    TrackedControllerRole_Max = 5
  );

  ETrackingUniverseOrigin = (
    TrackingUniverseSeated = 0,
    TrackingUniverseStanding = 1,
    TrackingUniverseRawAndUncalibrated = 2
  );

  EAdditionalRadioFeatures = (
    AdditionalRadioFeatures_None = 0,
    AdditionalRadioFeatures_HTCLinkBox = 1,
    AdditionalRadioFeatures_InternalDongle = 2,
    AdditionalRadioFeatures_ExternalDongle = 4
  );

  ETrackedDeviceProperty = (
    Prop_Invalid = 0,
    Prop_TrackingSystemName_String = 1000,
    Prop_ModelNumber_String = 1001,
    Prop_SerialNumber_String = 1002,
    Prop_RenderModelName_String = 1003,
    Prop_WillDriftInYaw_Bool = 1004,
    Prop_ManufacturerName_String = 1005,
    Prop_TrackingFirmwareVersion_String = 1006,
    Prop_HardwareRevision_String = 1007,
    Prop_AllWirelessDongleDescriptions_String = 1008,
    Prop_ConnectedWirelessDongle_String = 1009,
    Prop_DeviceIsWireless_Bool = 1010,
    Prop_DeviceIsCharging_Bool = 1011,
    Prop_DeviceBatteryPercentage_Float = 1012,
    Prop_StatusDisplayTransform_Matrix34 = 1013,
    Prop_Firmware_UpdateAvailable_Bool = 1014,
    Prop_Firmware_ManualUpdate_Bool = 1015,
    Prop_Firmware_ManualUpdateURL_String = 1016,
    Prop_HardwareRevision_Uint64 = 1017,
    Prop_FirmwareVersion_Uint64 = 1018,
    Prop_FPGAVersion_Uint64 = 1019,
    Prop_VRCVersion_Uint64 = 1020,
    Prop_RadioVersion_Uint64 = 1021,
    Prop_DongleVersion_Uint64 = 1022,
    Prop_BlockServerShutdown_Bool = 1023,
    Prop_CanUnifyCoordinateSystemWithHmd_Bool = 1024,
    Prop_ContainsProximitySensor_Bool = 1025,
    Prop_DeviceProvidesBatteryStatus_Bool = 1026,
    Prop_DeviceCanPowerOff_Bool = 1027,
    Prop_Firmware_ProgrammingTarget_String = 1028,
    Prop_DeviceClass_Int32 = 1029,
    Prop_HasCamera_Bool = 1030,
    Prop_DriverVersion_String = 1031,
    Prop_Firmware_ForceUpdateRequired_Bool = 1032,
    Prop_ViveSystemButtonFixRequired_Bool = 1033,
    Prop_ParentDriver_Uint64 = 1034,
    Prop_ResourceRoot_String = 1035,
    Prop_RegisteredDeviceType_String = 1036,
    Prop_InputProfilePath_String = 1037,
    Prop_NeverTracked_Bool = 1038,
    Prop_NumCameras_Int32 = 1039,
    Prop_CameraFrameLayout_Int32 = 1040,
    Prop_CameraStreamFormat_Int32 = 1041,
    Prop_AdditionalDeviceSettingsPath_String = 1042,
    Prop_Identifiable_Bool = 1043,
    Prop_BootloaderVersion_Uint64 = 1044,
    Prop_AdditionalSystemReportData_String = 1045,
    Prop_CompositeFirmwareVersion_String = 1046,
    Prop_Firmware_RemindUpdate_Bool = 1047,
    Prop_PeripheralApplicationVersion_Uint64 = 1048,
    Prop_ManufacturerSerialNumber_String = 1049,
    Prop_ComputedSerialNumber_String = 1050,
    Prop_EstimatedDeviceFirstUseTime_Int32 = 1051,
    Prop_ReportsTimeSinceVSync_Bool = 2000,
    Prop_SecondsFromVsyncToPhotons_Float = 2001,
    Prop_DisplayFrequency_Float = 2002,
    Prop_UserIpdMeters_Float = 2003,
    Prop_CurrentUniverseId_Uint64 = 2004,
    Prop_PreviousUniverseId_Uint64 = 2005,
    Prop_DisplayFirmwareVersion_Uint64 = 2006,
    Prop_IsOnDesktop_Bool = 2007,
    Prop_DisplayMCType_Int32 = 2008,
    Prop_DisplayMCOffset_Float = 2009,
    Prop_DisplayMCScale_Float = 2010,
    Prop_EdidVendorID_Int32 = 2011,
    Prop_DisplayMCImageLeft_String = 2012,
    Prop_DisplayMCImageRight_String = 2013,
    Prop_DisplayGCBlackClamp_Float = 2014,
    Prop_EdidProductID_Int32 = 2015,
    Prop_CameraToHeadTransform_Matrix34 = 2016,
    Prop_DisplayGCType_Int32 = 2017,
    Prop_DisplayGCOffset_Float = 2018,
    Prop_DisplayGCScale_Float = 2019,
    Prop_DisplayGCPrescale_Float = 2020,
    Prop_DisplayGCImage_String = 2021,
    Prop_LensCenterLeftU_Float = 2022,
    Prop_LensCenterLeftV_Float = 2023,
    Prop_LensCenterRightU_Float = 2024,
    Prop_LensCenterRightV_Float = 2025,
    Prop_UserHeadToEyeDepthMeters_Float = 2026,
    Prop_CameraFirmwareVersion_Uint64 = 2027,
    Prop_CameraFirmwareDescription_String = 2028,
    Prop_DisplayFPGAVersion_Uint64 = 2029,
    Prop_DisplayBootloaderVersion_Uint64 = 2030,
    Prop_DisplayHardwareVersion_Uint64 = 2031,
    Prop_AudioFirmwareVersion_Uint64 = 2032,
    Prop_CameraCompatibilityMode_Int32 = 2033,
    Prop_ScreenshotHorizontalFieldOfViewDegrees_Float = 2034,
    Prop_ScreenshotVerticalFieldOfViewDegrees_Float = 2035,
    Prop_DisplaySuppressed_Bool = 2036,
    Prop_DisplayAllowNightMode_Bool = 2037,
    Prop_DisplayMCImageWidth_Int32 = 2038,
    Prop_DisplayMCImageHeight_Int32 = 2039,
    Prop_DisplayMCImageNumChannels_Int32 = 2040,
    Prop_DisplayMCImageData_Binary = 2041,
    Prop_SecondsFromPhotonsToVblank_Float = 2042,
    Prop_DriverDirectModeSendsVsyncEvents_Bool = 2043,
    Prop_DisplayDebugMode_Bool = 2044,
    Prop_GraphicsAdapterLuid_Uint64 = 2045,
    Prop_DriverProvidedChaperonePath_String = 2048,
    Prop_ExpectedTrackingReferenceCount_Int32 = 2049,
    Prop_ExpectedControllerCount_Int32 = 2050,
    Prop_NamedIconPathControllerLeftDeviceOff_String = 2051,
    Prop_NamedIconPathControllerRightDeviceOff_String = 2052,
    Prop_NamedIconPathTrackingReferenceDeviceOff_String = 2053,
    Prop_DoNotApplyPrediction_Bool = 2054,
    Prop_CameraToHeadTransforms_Matrix34_Array = 2055,
    Prop_DistortionMeshResolution_Int32 = 2056,
    Prop_DriverIsDrawingControllers_Bool = 2057,
    Prop_DriverRequestsApplicationPause_Bool = 2058,
    Prop_DriverRequestsReducedRendering_Bool = 2059,
    Prop_MinimumIpdStepMeters_Float = 2060,
    Prop_AudioBridgeFirmwareVersion_Uint64 = 2061,
    Prop_ImageBridgeFirmwareVersion_Uint64 = 2062,
    Prop_ImuToHeadTransform_Matrix34 = 2063,
    Prop_ImuFactoryGyroBias_Vector3 = 2064,
    Prop_ImuFactoryGyroScale_Vector3 = 2065,
    Prop_ImuFactoryAccelerometerBias_Vector3 = 2066,
    Prop_ImuFactoryAccelerometerScale_Vector3 = 2067,
    Prop_ConfigurationIncludesLighthouse20Features_Bool = 2069,
    Prop_AdditionalRadioFeatures_Uint64 = 2070,
    Prop_CameraWhiteBalance_Vector4_Array = 2071,
    Prop_CameraDistortionFunction_Int32_Array = 2072,
    Prop_CameraDistortionCoefficients_Float_Array = 2073,
    Prop_ExpectedControllerType_String = 2074,
    Prop_HmdTrackingStyle_Int32 = 2075,
    Prop_DriverProvidedChaperoneVisibility_Bool = 2076,
    Prop_HmdColumnCorrectionSettingPrefix_String = 2077,
    Prop_CameraSupportsCompatibilityModes_Bool = 2078,
    Prop_SupportsRoomViewDepthProjection_Bool = 2079,
    Prop_DisplayAvailableFrameRates_Float_Array = 2080,
    Prop_DisplaySupportsMultipleFramerates_Bool = 2081,
    Prop_DisplayColorMultLeft_Vector3 = 2082,
    Prop_DisplayColorMultRight_Vector3 = 2083,
    Prop_DisplaySupportsRuntimeFramerateChange_Bool = 2084,
    Prop_DisplaySupportsAnalogGain_Bool = 2085,
    Prop_DisplayMinAnalogGain_Float = 2086,
    Prop_DisplayMaxAnalogGain_Float = 2087,
    Prop_DashboardScale_Float = 2091,
    Prop_IpdUIRangeMinMeters_Float = 2100,
    Prop_IpdUIRangeMaxMeters_Float = 2101,
    Prop_DriverRequestedMuraCorrectionMode_Int32 = 2200,
    Prop_DriverRequestedMuraFeather_InnerLeft_Int32 = 2201,
    Prop_DriverRequestedMuraFeather_InnerRight_Int32 = 2202,
    Prop_DriverRequestedMuraFeather_InnerTop_Int32 = 2203,
    Prop_DriverRequestedMuraFeather_InnerBottom_Int32 = 2204,
    Prop_DriverRequestedMuraFeather_OuterLeft_Int32 = 2205,
    Prop_DriverRequestedMuraFeather_OuterRight_Int32 = 2206,
    Prop_DriverRequestedMuraFeather_OuterTop_Int32 = 2207,
    Prop_DriverRequestedMuraFeather_OuterBottom_Int32 = 2208,
    Prop_Audio_DefaultPlaybackDeviceId_String = 2300,
    Prop_Audio_DefaultRecordingDeviceId_String = 2301,
    Prop_Audio_DefaultPlaybackDeviceVolume_Float = 2302,
    Prop_Audio_SupportsDualSpeakerAndJackOutput_Bool = 2303,
    Prop_AttachedDeviceId_String = 3000,
    Prop_SupportedButtons_Uint64 = 3001,
    Prop_Axis0Type_Int32 = 3002,
    Prop_Axis1Type_Int32 = 3003,
    Prop_Axis2Type_Int32 = 3004,
    Prop_Axis3Type_Int32 = 3005,
    Prop_Axis4Type_Int32 = 3006,
    Prop_ControllerRoleHint_Int32 = 3007,
    Prop_FieldOfViewLeftDegrees_Float = 4000,
    Prop_FieldOfViewRightDegrees_Float = 4001,
    Prop_FieldOfViewTopDegrees_Float = 4002,
    Prop_FieldOfViewBottomDegrees_Float = 4003,
    Prop_TrackingRangeMinimumMeters_Float = 4004,
    Prop_TrackingRangeMaximumMeters_Float = 4005,
    Prop_ModeLabel_String = 4006,
    Prop_CanWirelessIdentify_Bool = 4007,
    Prop_Nonce_Int32 = 4008,
    Prop_IconPathName_String = 5000,
    Prop_NamedIconPathDeviceOff_String = 5001,
    Prop_NamedIconPathDeviceSearching_String = 5002,
    Prop_NamedIconPathDeviceSearchingAlert_String = 5003,
    Prop_NamedIconPathDeviceReady_String = 5004,
    Prop_NamedIconPathDeviceReadyAlert_String = 5005,
    Prop_NamedIconPathDeviceNotReady_String = 5006,
    Prop_NamedIconPathDeviceStandby_String = 5007,
    Prop_NamedIconPathDeviceAlertLow_String = 5008,
    Prop_NamedIconPathDeviceStandbyAlert_String = 5009,
    Prop_DisplayHiddenArea_Binary_Start = 5100,
    Prop_DisplayHiddenArea_Binary_End = 5150,
    Prop_ParentContainer = 5151,
    Prop_OverrideContainer_Uint64 = 5152,
    Prop_UserConfigPath_String = 6000,
    Prop_InstallPath_String = 6001,
    Prop_HasDisplayComponent_Bool = 6002,
    Prop_HasControllerComponent_Bool = 6003,
    Prop_HasCameraComponent_Bool = 6004,
    Prop_HasDriverDirectModeComponent_Bool = 6005,
    Prop_HasVirtualDisplayComponent_Bool = 6006,
    Prop_HasSpatialAnchorsSupport_Bool = 6007,
    Prop_ControllerType_String = 7000,
    Prop_ControllerHandSelectionPriority_Int32 = 7002,
    Prop_VendorSpecific_Reserved_Start = 10000,
    Prop_VendorSpecific_Reserved_End = 10999,
    Prop_TrackedDeviceProperty_Max = 1000000
  );

  ETrackedPropertyError = (
    TrackedProp_Success = 0,
    TrackedProp_WrongDataType = 1,
    TrackedProp_WrongDeviceClass = 2,
    TrackedProp_BufferTooSmall = 3,
    TrackedProp_UnknownProperty = 4,
    TrackedProp_InvalidDevice = 5,
    TrackedProp_CouldNotContactServer = 6,
    TrackedProp_ValueNotProvidedByDevice = 7,
    TrackedProp_StringExceedsMaximumLength = 8,
    TrackedProp_NotYetAvailable = 9,
    TrackedProp_PermissionDenied = 10,
    TrackedProp_InvalidOperation = 11,
    TrackedProp_CannotWriteToWildcards = 12,
    TrackedProp_IPCReadFailure = 13,
    TrackedProp_OutOfMemory = 14,
    TrackedProp_InvalidContainer = 15
  );

  EHmdTrackingStyle = (
    HmdTrackingStyle_Unknown = 0,
    HmdTrackingStyle_Lighthouse = 1,
    HmdTrackingStyle_OutsideInCameras = 2,
    HmdTrackingStyle_InsideOutCameras = 3
  );

  EVRSubmitFlags = (
    Submit_Default = 0,
    Submit_LensDistortionAlreadyApplied = 1,
    Submit_GlRenderBuffer = 2,
    Submit_Reserved = 4,
    Submit_TextureWithPose = 8,
    Submit_TextureWithDepth = 16,
    Submit_FrameDiscontinuty = 32,
    Submit_VulkanTextureWithArrayData = 64
  );

  EVRState = (
    VRState_Undefined = -1,
    VRState_Off = 0,
    VRState_Searching = 1,
    VRState_Searching_Alert = 2,
    VRState_Ready = 3,
    VRState_Ready_Alert = 4,
    VRState_NotReady = 5,
    VRState_Standby = 6,
    VRState_Ready_Alert_Low = 7
  );

  EVREventType = (
    VREvent_None = 0,
    VREvent_TrackedDeviceActivated = 100,
    VREvent_TrackedDeviceDeactivated = 101,
    VREvent_TrackedDeviceUpdated = 102,
    VREvent_TrackedDeviceUserInteractionStarted = 103,
    VREvent_TrackedDeviceUserInteractionEnded = 104,
    VREvent_IpdChanged = 105,
    VREvent_EnterStandbyMode = 106,
    VREvent_LeaveStandbyMode = 107,
    VREvent_TrackedDeviceRoleChanged = 108,
    VREvent_WatchdogWakeUpRequested = 109,
    VREvent_LensDistortionChanged = 110,
    VREvent_PropertyChanged = 111,
    VREvent_WirelessDisconnect = 112,
    VREvent_WirelessReconnect = 113,
    VREvent_ButtonPress = 200,
    VREvent_ButtonUnpress = 201,
    VREvent_ButtonTouch = 202,
    VREvent_ButtonUntouch = 203,
    VREvent_Modal_Cancel = 257,
    VREvent_MouseMove = 300,
    VREvent_MouseButtonDown = 301,
    VREvent_MouseButtonUp = 302,
    VREvent_FocusEnter = 303,
    VREvent_FocusLeave = 304,
    VREvent_ScrollDiscrete = 305,
    VREvent_TouchPadMove = 306,
    VREvent_OverlayFocusChanged = 307,
    VREvent_ReloadOverlays = 308,
    VREvent_ScrollSmooth = 309,
    VREvent_LockMousePosition = 310,
    VREvent_UnlockMousePosition = 311,
    VREvent_InputFocusCaptured = 400,
    VREvent_InputFocusReleased = 401,
    VREvent_SceneApplicationChanged = 404,
    VREvent_SceneFocusChanged = 405,
    VREvent_InputFocusChanged = 406,
    VREvent_SceneApplicationUsingWrongGraphicsAdapter = 408,
    VREvent_ActionBindingReloaded = 409,
    VREvent_HideRenderModels = 410,
    VREvent_ShowRenderModels = 411,
    VREvent_SceneApplicationStateChanged = 412,
    VREvent_ConsoleOpened = 420,
    VREvent_ConsoleClosed = 421,
    VREvent_OverlayShown = 500,
    VREvent_OverlayHidden = 501,
    VREvent_DashboardActivated = 502,
    VREvent_DashboardDeactivated = 503,
    VREvent_DashboardRequested = 505,
    VREvent_ResetDashboard = 506,
    VREvent_ImageLoaded = 508,
    VREvent_ShowKeyboard = 509,
    VREvent_HideKeyboard = 510,
    VREvent_OverlayGamepadFocusGained = 511,
    VREvent_OverlayGamepadFocusLost = 512,
    VREvent_OverlaySharedTextureChanged = 513,
    VREvent_ScreenshotTriggered = 516,
    VREvent_ImageFailed = 517,
    VREvent_DashboardOverlayCreated = 518,
    VREvent_SwitchGamepadFocus = 519,
    VREvent_RequestScreenshot = 520,
    VREvent_ScreenshotTaken = 521,
    VREvent_ScreenshotFailed = 522,
    VREvent_SubmitScreenshotToDashboard = 523,
    VREvent_ScreenshotProgressToDashboard = 524,
    VREvent_PrimaryDashboardDeviceChanged = 525,
    VREvent_RoomViewShown = 526,
    VREvent_RoomViewHidden = 527,
    VREvent_ShowUI = 528,
    VREvent_ShowDevTools = 529,
    VREvent_DesktopViewUpdating = 530,
    VREvent_DesktopViewReady = 531,
    VREvent_Notification_Shown = 600,
    VREvent_Notification_Hidden = 601,
    VREvent_Notification_BeginInteraction = 602,
    VREvent_Notification_Destroyed = 603,
    VREvent_Quit = 700,
    VREvent_ProcessQuit = 701,
    VREvent_QuitAcknowledged = 703,
    VREvent_DriverRequestedQuit = 704,
    VREvent_RestartRequested = 705,
    VREvent_ChaperoneDataHasChanged = 800,
    VREvent_ChaperoneUniverseHasChanged = 801,
    VREvent_ChaperoneTempDataHasChanged = 802,
    VREvent_ChaperoneSettingsHaveChanged = 803,
    VREvent_SeatedZeroPoseReset = 804,
    VREvent_ChaperoneFlushCache = 805,
    VREvent_ChaperoneRoomSetupStarting = 806,
    VREvent_ChaperoneRoomSetupFinished = 807,
    VREvent_StandingZeroPoseReset = 808,
    VREvent_AudioSettingsHaveChanged = 820,
    VREvent_BackgroundSettingHasChanged = 850,
    VREvent_CameraSettingsHaveChanged = 851,
    VREvent_ReprojectionSettingHasChanged = 852,
    VREvent_ModelSkinSettingsHaveChanged = 853,
    VREvent_EnvironmentSettingsHaveChanged = 854,
    VREvent_PowerSettingsHaveChanged = 855,
    VREvent_EnableHomeAppSettingsHaveChanged = 856,
    VREvent_SteamVRSectionSettingChanged = 857,
    VREvent_LighthouseSectionSettingChanged = 858,
    VREvent_NullSectionSettingChanged = 859,
    VREvent_UserInterfaceSectionSettingChanged = 860,
    VREvent_NotificationsSectionSettingChanged = 861,
    VREvent_KeyboardSectionSettingChanged = 862,
    VREvent_PerfSectionSettingChanged = 863,
    VREvent_DashboardSectionSettingChanged = 864,
    VREvent_WebInterfaceSectionSettingChanged = 865,
    VREvent_TrackersSectionSettingChanged = 866,
    VREvent_LastKnownSectionSettingChanged = 867,
    VREvent_DismissedWarningsSectionSettingChanged = 868,
    VREvent_GpuSpeedSectionSettingChanged = 869,
    VREvent_WindowsMRSectionSettingChanged = 870,
    VREvent_OtherSectionSettingChanged = 871,
    VREvent_StatusUpdate = 900,
    VREvent_WebInterface_InstallDriverCompleted = 950,
    VREvent_MCImageUpdated = 1000,
    VREvent_FirmwareUpdateStarted = 1100,
    VREvent_FirmwareUpdateFinished = 1101,
    VREvent_KeyboardClosed = 1200,
    VREvent_KeyboardCharInput = 1201,
    VREvent_KeyboardDone = 1202,
    VREvent_ApplicationListUpdated = 1303,
    VREvent_ApplicationMimeTypeLoad = 1304,
    VREvent_ProcessConnected = 1306,
    VREvent_ProcessDisconnected = 1307,
    VREvent_Compositor_ChaperoneBoundsShown = 1410,
    VREvent_Compositor_ChaperoneBoundsHidden = 1411,
    VREvent_Compositor_DisplayDisconnected = 1412,
    VREvent_Compositor_DisplayReconnected = 1413,
    VREvent_Compositor_HDCPError = 1414,
    VREvent_Compositor_ApplicationNotResponding = 1415,
    VREvent_Compositor_ApplicationResumed = 1416,
    VREvent_Compositor_OutOfVideoMemory = 1417,
    VREvent_Compositor_DisplayModeNotSupported = 1418,
    VREvent_Compositor_StageOverrideReady = 1419,
    VREvent_TrackedCamera_StartVideoStream = 1500,
    VREvent_TrackedCamera_StopVideoStream = 1501,
    VREvent_TrackedCamera_PauseVideoStream = 1502,
    VREvent_TrackedCamera_ResumeVideoStream = 1503,
    VREvent_TrackedCamera_EditingSurface = 1550,
    VREvent_PerformanceTest_EnableCapture = 1600,
    VREvent_PerformanceTest_DisableCapture = 1601,
    VREvent_PerformanceTest_FidelityLevel = 1602,
    VREvent_MessageOverlay_Closed = 1650,
    VREvent_MessageOverlayCloseRequested = 1651,
    VREvent_Input_HapticVibration = 1700,
    VREvent_Input_BindingLoadFailed = 1701,
    VREvent_Input_BindingLoadSuccessful = 1702,
    VREvent_Input_ActionManifestReloaded = 1703,
    VREvent_Input_ActionManifestLoadFailed = 1704,
    VREvent_Input_ProgressUpdate = 1705,
    VREvent_Input_TrackerActivated = 1706,
    VREvent_Input_BindingsUpdated = 1707,
    VREvent_Input_BindingSubscriptionChanged = 1708,
    VREvent_SpatialAnchors_PoseUpdated = 1800,
    VREvent_SpatialAnchors_DescriptorUpdated = 1801,
    VREvent_SpatialAnchors_RequestPoseUpdate = 1802,
    VREvent_SpatialAnchors_RequestDescriptorUpdate = 1803,
    VREvent_SystemReport_Started = 1900,
    VREvent_Monitor_ShowHeadsetView = 2000,
    VREvent_Monitor_HideHeadsetView = 2001,
    VREvent_VendorSpecific_Reserved_Start = 10000,
    VREvent_VendorSpecific_Reserved_End = 19999
  );

  EDeviceActivityLevel = (
    k_EDeviceActivityLevel_Unknown = -1,
    k_EDeviceActivityLevel_Idle = 0,
    k_EDeviceActivityLevel_UserInteraction = 1,
    k_EDeviceActivityLevel_UserInteraction_Timeout = 2,
    k_EDeviceActivityLevel_Standby = 3,
    k_EDeviceActivityLevel_Idle_Timeout = 4
  );

  EVRButtonId = (
    k_EButton_System = 0,
    k_EButton_ApplicationMenu = 1,
    k_EButton_Grip = 2,
    k_EButton_DPad_Left = 3,
    k_EButton_DPad_Up = 4,
    k_EButton_DPad_Right = 5,
    k_EButton_DPad_Down = 6,
    k_EButton_A = 7,
    k_EButton_ProximitySensor = 31,
    k_EButton_Axis0 = 32,
    k_EButton_Axis1 = 33,
    k_EButton_Axis2 = 34,
    k_EButton_Axis3 = 35,
    k_EButton_Axis4 = 36,
    k_EButton_SteamVR_Touchpad = 32,
    k_EButton_SteamVR_Trigger = 33,
    k_EButton_Dashboard_Back = 2,
    k_EButton_IndexController_A = 2,
    k_EButton_IndexController_B = 1,
    k_EButton_IndexController_JoyStick = 35,
    k_EButton_Max = 64
  );

  EVRMouseButton = (
    VRMouseButton_Left = 1,
    VRMouseButton_Right = 2,
    VRMouseButton_Middle = 4
  );

  EShowUIType = (
    ShowUI_ControllerBinding = 0,
    ShowUI_ManageTrackers = 1,
    ShowUI_Pairing = 3,
    ShowUI_Settings = 4,
    ShowUI_DebugCommands = 5,
    ShowUI_FullControllerBinding = 6,
    ShowUI_ManageDrivers = 7
  );

  EHDCPError = (
    HDCPError_None = 0,
    HDCPError_LinkLost = 1,
    HDCPError_Tampered = 2,
    HDCPError_DeviceRevoked = 3,
    HDCPError_Unknown = 4
  );

  EVRComponentProperty = (
    VRComponentProperty_IsStatic = 1,
    VRComponentProperty_IsVisible = 2,
    VRComponentProperty_IsTouched = 4,
    VRComponentProperty_IsPressed = 8,
    VRComponentProperty_IsScrolled = 16,
    VRComponentProperty_IsHighlighted = 32
  );

  EVRInputError = (
    VRInputError_None = 0,
    VRInputError_NameNotFound = 1,
    VRInputError_WrongType = 2,
    VRInputError_InvalidHandle = 3,
    VRInputError_InvalidParam = 4,
    VRInputError_NoSteam = 5,
    VRInputError_MaxCapacityReached = 6,
    VRInputError_IPCError = 7,
    VRInputError_NoActiveActionSet = 8,
    VRInputError_InvalidDevice = 9,
    VRInputError_InvalidSkeleton = 10,
    VRInputError_InvalidBoneCount = 11,
    VRInputError_InvalidCompressedData = 12,
    VRInputError_NoData = 13,
    VRInputError_BufferTooSmall = 14,
    VRInputError_MismatchedActionManifest = 15,
    VRInputError_MissingSkeletonData = 16,
    VRInputError_InvalidBoneIndex = 17,
    VRInputError_InvalidPriority = 18,
    VRInputError_PermissionDenied = 19,
    VRInputError_InvalidRenderModel = 20
  );

  EVRSpatialAnchorError = (
    VRSpatialAnchorError_Success = 0,
    VRSpatialAnchorError_Internal = 1,
    VRSpatialAnchorError_UnknownHandle = 2,
    VRSpatialAnchorError_ArrayTooSmall = 3,
    VRSpatialAnchorError_InvalidDescriptorChar = 4,
    VRSpatialAnchorError_NotYetAvailable = 5,
    VRSpatialAnchorError_NotAvailableInThisUniverse = 6,
    VRSpatialAnchorError_PermanentlyUnavailable = 7,
    VRSpatialAnchorError_WrongDriver = 8,
    VRSpatialAnchorError_DescriptorTooLong = 9,
    VRSpatialAnchorError_Unknown = 10,
    VRSpatialAnchorError_NoRoomCalibration = 11,
    VRSpatialAnchorError_InvalidArgument = 12,
    VRSpatialAnchorError_UnknownDriver = 13
  );

  EHiddenAreaMeshType = (
    k_eHiddenAreaMesh_Standard = 0,
    k_eHiddenAreaMesh_Inverse = 1,
    k_eHiddenAreaMesh_LineLoop = 2,
    k_eHiddenAreaMesh_Max = 3
  );

  EVRControllerAxisType = (
    k_eControllerAxis_None = 0,
    k_eControllerAxis_TrackPad = 1,
    k_eControllerAxis_Joystick = 2,
    k_eControllerAxis_Trigger = 3
  );

  EVRControllerEventOutputType = (
    ControllerEventOutput_OSEvents = 0,
    ControllerEventOutput_VREvents = 1
  );

  ECollisionBoundsStyle = (
    COLLISION_BOUNDS_STYLE_BEGINNER = 0,
    COLLISION_BOUNDS_STYLE_INTERMEDIATE = 1,
    COLLISION_BOUNDS_STYLE_SQUARES = 2,
    COLLISION_BOUNDS_STYLE_ADVANCED = 3,
    COLLISION_BOUNDS_STYLE_NONE = 4,
    COLLISION_BOUNDS_STYLE_COUNT = 5
  );

  EVROverlayError = (
    VROverlayError_None = 0,
    VROverlayError_UnknownOverlay = 10,
    VROverlayError_InvalidHandle = 11,
    VROverlayError_PermissionDenied = 12,
    VROverlayError_OverlayLimitExceeded = 13,
    VROverlayError_WrongVisibilityType = 14,
    VROverlayError_KeyTooLong = 15,
    VROverlayError_NameTooLong = 16,
    VROverlayError_KeyInUse = 17,
    VROverlayError_WrongTransformType = 18,
    VROverlayError_InvalidTrackedDevice = 19,
    VROverlayError_InvalidParameter = 20,
    VROverlayError_ThumbnailCantBeDestroyed = 21,
    VROverlayError_ArrayTooSmall = 22,
    VROverlayError_RequestFailed = 23,
    VROverlayError_InvalidTexture = 24,
    VROverlayError_UnableToLoadFile = 25,
    VROverlayError_KeyboardAlreadyInUse = 26,
    VROverlayError_NoNeighbor = 27,
    VROverlayError_TooManyMaskPrimitives = 29,
    VROverlayError_BadMaskPrimitive = 30,
    VROverlayError_TextureAlreadyLocked = 31,
    VROverlayError_TextureLockCapacityReached = 32,
    VROverlayError_TextureNotLocked = 33
  );

  EVRApplicationType = (
    VRApplication_Other = 0,
    VRApplication_Scene = 1,
    VRApplication_Overlay = 2,
    VRApplication_Background = 3,
    VRApplication_Utility = 4,
    VRApplication_VRMonitor = 5,
    VRApplication_SteamWatchdog = 6,
    VRApplication_Bootstrapper = 7,
    VRApplication_WebHelper = 8,
    VRApplication_OpenXR = 9,
    VRApplication_Max = 10
  );

  EVRFirmwareError = (
    VRFirmwareError_None = 0,
    VRFirmwareError_Success = 1,
    VRFirmwareError_Fail = 2
  );

  EVRNotificationError = (
    VRNotificationError_OK = 0,
    VRNotificationError_InvalidNotificationId = 100,
    VRNotificationError_NotificationQueueFull = 101,
    VRNotificationError_InvalidOverlayHandle = 102,
    VRNotificationError_SystemWithUserValueAlreadyExists = 103
  );

  EVRSkeletalMotionRange = (
    VRSkeletalMotionRange_WithController = 0,
    VRSkeletalMotionRange_WithoutController = 1
  );

  EVRSkeletalTrackingLevel = (
    VRSkeletalTracking_Estimated = 0,
    VRSkeletalTracking_Partial = 1,
    VRSkeletalTracking_Full = 2,
    VRSkeletalTrackingLevel_Count = 3,
    VRSkeletalTrackingLevel_Max = 2
  );

  EVRInitError = (
    VRInitError_None = 0,
    VRInitError_Unknown = 1,
    VRInitError_Init_InstallationNotFound = 100,
    VRInitError_Init_InstallationCorrupt = 101,
    VRInitError_Init_VRClientDLLNotFound = 102,
    VRInitError_Init_FileNotFound = 103,
    VRInitError_Init_FactoryNotFound = 104,
    VRInitError_Init_InterfaceNotFound = 105,
    VRInitError_Init_InvalidInterface = 106,
    VRInitError_Init_UserConfigDirectoryInvalid = 107,
    VRInitError_Init_HmdNotFound = 108,
    VRInitError_Init_NotInitialized = 109,
    VRInitError_Init_PathRegistryNotFound = 110,
    VRInitError_Init_NoConfigPath = 111,
    VRInitError_Init_NoLogPath = 112,
    VRInitError_Init_PathRegistryNotWritable = 113,
    VRInitError_Init_AppInfoInitFailed = 114,
    VRInitError_Init_Retry = 115,
    VRInitError_Init_InitCanceledByUser = 116,
    VRInitError_Init_AnotherAppLaunching = 117,
    VRInitError_Init_SettingsInitFailed = 118,
    VRInitError_Init_ShuttingDown = 119,
    VRInitError_Init_TooManyObjects = 120,
    VRInitError_Init_NoServerForBackgroundApp = 121,
    VRInitError_Init_NotSupportedWithCompositor = 122,
    VRInitError_Init_NotAvailableToUtilityApps = 123,
    VRInitError_Init_Internal = 124,
    VRInitError_Init_HmdDriverIdIsNone = 125,
    VRInitError_Init_HmdNotFoundPresenceFailed = 126,
    VRInitError_Init_VRMonitorNotFound = 127,
    VRInitError_Init_VRMonitorStartupFailed = 128,
    VRInitError_Init_LowPowerWatchdogNotSupported = 129,
    VRInitError_Init_InvalidApplicationType = 130,
    VRInitError_Init_NotAvailableToWatchdogApps = 131,
    VRInitError_Init_WatchdogDisabledInSettings = 132,
    VRInitError_Init_VRDashboardNotFound = 133,
    VRInitError_Init_VRDashboardStartupFailed = 134,
    VRInitError_Init_VRHomeNotFound = 135,
    VRInitError_Init_VRHomeStartupFailed = 136,
    VRInitError_Init_RebootingBusy = 137,
    VRInitError_Init_FirmwareUpdateBusy = 138,
    VRInitError_Init_FirmwareRecoveryBusy = 139,
    VRInitError_Init_USBServiceBusy = 140,
    VRInitError_Init_VRWebHelperStartupFailed = 141,
    VRInitError_Init_TrackerManagerInitFailed = 142,
    VRInitError_Init_AlreadyRunning = 143,
    VRInitError_Init_FailedForVrMonitor = 144,
    VRInitError_Init_PropertyManagerInitFailed = 145,
    VRInitError_Init_WebServerFailed = 146,
    VRInitError_Driver_Failed = 200,
    VRInitError_Driver_Unknown = 201,
    VRInitError_Driver_HmdUnknown = 202,
    VRInitError_Driver_NotLoaded = 203,
    VRInitError_Driver_RuntimeOutOfDate = 204,
    VRInitError_Driver_HmdInUse = 205,
    VRInitError_Driver_NotCalibrated = 206,
    VRInitError_Driver_CalibrationInvalid = 207,
    VRInitError_Driver_HmdDisplayNotFound = 208,
    VRInitError_Driver_TrackedDeviceInterfaceUnknown = 209,
    VRInitError_Driver_HmdDriverIdOutOfBounds = 211,
    VRInitError_Driver_HmdDisplayMirrored = 212,
    VRInitError_Driver_HmdDisplayNotFoundLaptop = 213,
    VRInitError_IPC_ServerInitFailed = 300,
    VRInitError_IPC_ConnectFailed = 301,
    VRInitError_IPC_SharedStateInitFailed = 302,
    VRInitError_IPC_CompositorInitFailed = 303,
    VRInitError_IPC_MutexInitFailed = 304,
    VRInitError_IPC_Failed = 305,
    VRInitError_IPC_CompositorConnectFailed = 306,
    VRInitError_IPC_CompositorInvalidConnectResponse = 307,
    VRInitError_IPC_ConnectFailedAfterMultipleAttempts = 308,
    VRInitError_IPC_ConnectFailedAfterTargetExited = 309,
    VRInitError_IPC_NamespaceUnavailable = 310,
    VRInitError_Compositor_Failed = 400,
    VRInitError_Compositor_D3D11HardwareRequired = 401,
    VRInitError_Compositor_FirmwareRequiresUpdate = 402,
    VRInitError_Compositor_OverlayInitFailed = 403,
    VRInitError_Compositor_ScreenshotsInitFailed = 404,
    VRInitError_Compositor_UnableToCreateDevice = 405,
    VRInitError_Compositor_SharedStateIsNull = 406,
    VRInitError_Compositor_NotificationManagerIsNull = 407,
    VRInitError_Compositor_ResourceManagerClientIsNull = 408,
    VRInitError_Compositor_MessageOverlaySharedStateInitFailure = 409,
    VRInitError_Compositor_PropertiesInterfaceIsNull = 410,
    VRInitError_Compositor_CreateFullscreenWindowFailed = 411,
    VRInitError_Compositor_SettingsInterfaceIsNull = 412,
    VRInitError_Compositor_FailedToShowWindow = 413,
    VRInitError_Compositor_DistortInterfaceIsNull = 414,
    VRInitError_Compositor_DisplayFrequencyFailure = 415,
    VRInitError_Compositor_RendererInitializationFailed = 416,
    VRInitError_Compositor_DXGIFactoryInterfaceIsNull = 417,
    VRInitError_Compositor_DXGIFactoryCreateFailed = 418,
    VRInitError_Compositor_DXGIFactoryQueryFailed = 419,
    VRInitError_Compositor_InvalidAdapterDesktop = 420,
    VRInitError_Compositor_InvalidHmdAttachment = 421,
    VRInitError_Compositor_InvalidOutputDesktop = 422,
    VRInitError_Compositor_InvalidDeviceProvided = 423,
    VRInitError_Compositor_D3D11RendererInitializationFailed = 424,
    VRInitError_Compositor_FailedToFindDisplayMode = 425,
    VRInitError_Compositor_FailedToCreateSwapChain = 426,
    VRInitError_Compositor_FailedToGetBackBuffer = 427,
    VRInitError_Compositor_FailedToCreateRenderTarget = 428,
    VRInitError_Compositor_FailedToCreateDXGI2SwapChain = 429,
    VRInitError_Compositor_FailedtoGetDXGI2BackBuffer = 430,
    VRInitError_Compositor_FailedToCreateDXGI2RenderTarget = 431,
    VRInitError_Compositor_FailedToGetDXGIDeviceInterface = 432,
    VRInitError_Compositor_SelectDisplayMode = 433,
    VRInitError_Compositor_FailedToCreateNvAPIRenderTargets = 434,
    VRInitError_Compositor_NvAPISetDisplayMode = 435,
    VRInitError_Compositor_FailedToCreateDirectModeDisplay = 436,
    VRInitError_Compositor_InvalidHmdPropertyContainer = 437,
    VRInitError_Compositor_UpdateDisplayFrequency = 438,
    VRInitError_Compositor_CreateRasterizerState = 439,
    VRInitError_Compositor_CreateWireframeRasterizerState = 440,
    VRInitError_Compositor_CreateSamplerState = 441,
    VRInitError_Compositor_CreateClampToBorderSamplerState = 442,
    VRInitError_Compositor_CreateAnisoSamplerState = 443,
    VRInitError_Compositor_CreateOverlaySamplerState = 444,
    VRInitError_Compositor_CreatePanoramaSamplerState = 445,
    VRInitError_Compositor_CreateFontSamplerState = 446,
    VRInitError_Compositor_CreateNoBlendState = 447,
    VRInitError_Compositor_CreateBlendState = 448,
    VRInitError_Compositor_CreateAlphaBlendState = 449,
    VRInitError_Compositor_CreateBlendStateMaskR = 450,
    VRInitError_Compositor_CreateBlendStateMaskG = 451,
    VRInitError_Compositor_CreateBlendStateMaskB = 452,
    VRInitError_Compositor_CreateDepthStencilState = 453,
    VRInitError_Compositor_CreateDepthStencilStateNoWrite = 454,
    VRInitError_Compositor_CreateDepthStencilStateNoDepth = 455,
    VRInitError_Compositor_CreateFlushTexture = 456,
    VRInitError_Compositor_CreateDistortionSurfaces = 457,
    VRInitError_Compositor_CreateConstantBuffer = 458,
    VRInitError_Compositor_CreateHmdPoseConstantBuffer = 459,
    VRInitError_Compositor_CreateHmdPoseStagingConstantBuffer = 460,
    VRInitError_Compositor_CreateSharedFrameInfoConstantBuffer = 461,
    VRInitError_Compositor_CreateOverlayConstantBuffer = 462,
    VRInitError_Compositor_CreateSceneTextureIndexConstantBuffer = 463,
    VRInitError_Compositor_CreateReadableSceneTextureIndexConstantBuffer = 464,
    VRInitError_Compositor_CreateLayerGraphicsTextureIndexConstantBuffer = 465,
    VRInitError_Compositor_CreateLayerComputeTextureIndexConstantBuffer = 466,
    VRInitError_Compositor_CreateLayerComputeSceneTextureIndexConstantBuffer = 467,
    VRInitError_Compositor_CreateComputeHmdPoseConstantBuffer = 468,
    VRInitError_Compositor_CreateGeomConstantBuffer = 469,
    VRInitError_Compositor_CreatePanelMaskConstantBuffer = 470,
    VRInitError_Compositor_CreatePixelSimUBO = 471,
    VRInitError_Compositor_CreateMSAARenderTextures = 472,
    VRInitError_Compositor_CreateResolveRenderTextures = 473,
    VRInitError_Compositor_CreateComputeResolveRenderTextures = 474,
    VRInitError_Compositor_CreateDriverDirectModeResolveTextures = 475,
    VRInitError_Compositor_OpenDriverDirectModeResolveTextures = 476,
    VRInitError_Compositor_CreateFallbackSyncTexture = 477,
    VRInitError_Compositor_ShareFallbackSyncTexture = 478,
    VRInitError_Compositor_CreateOverlayIndexBuffer = 479,
    VRInitError_Compositor_CreateOverlayVertexBuffer = 480,
    VRInitError_Compositor_CreateTextVertexBuffer = 481,
    VRInitError_Compositor_CreateTextIndexBuffer = 482,
    VRInitError_Compositor_CreateMirrorTextures = 483,
    VRInitError_Compositor_CreateLastFrameRenderTexture = 484,
    VRInitError_Compositor_CreateMirrorOverlay = 485,
    VRInitError_Compositor_FailedToCreateVirtualDisplayBackbuffer = 486,
    VRInitError_Compositor_DisplayModeNotSupported = 487,
    VRInitError_Compositor_CreateOverlayInvalidCall = 488,
    VRInitError_Compositor_CreateOverlayAlreadyInitialized = 489,
    VRInitError_Compositor_FailedToCreateMailbox = 490,
    VRInitError_VendorSpecific_UnableToConnectToOculusRuntime = 1000,
    VRInitError_VendorSpecific_WindowsNotInDevMode = 1001,
    VRInitError_VendorSpecific_HmdFound_CantOpenDevice = 1101,
    VRInitError_VendorSpecific_HmdFound_UnableToRequestConfigStart = 1102,
    VRInitError_VendorSpecific_HmdFound_NoStoredConfig = 1103,
    VRInitError_VendorSpecific_HmdFound_ConfigTooBig = 1104,
    VRInitError_VendorSpecific_HmdFound_ConfigTooSmall = 1105,
    VRInitError_VendorSpecific_HmdFound_UnableToInitZLib = 1106,
    VRInitError_VendorSpecific_HmdFound_CantReadFirmwareVersion = 1107,
    VRInitError_VendorSpecific_HmdFound_UnableToSendUserDataStart = 1108,
    VRInitError_VendorSpecific_HmdFound_UnableToGetUserDataStart = 1109,
    VRInitError_VendorSpecific_HmdFound_UnableToGetUserDataNext = 1110,
    VRInitError_VendorSpecific_HmdFound_UserDataAddressRange = 1111,
    VRInitError_VendorSpecific_HmdFound_UserDataError = 1112,
    VRInitError_VendorSpecific_HmdFound_ConfigFailedSanityCheck = 1113,
    VRInitError_VendorSpecific_OculusRuntimeBadInstall = 1114,
    VRInitError_Steam_SteamInstallationNotFound = 2000,
    VRInitError_LastError = 2001
  );

  EVRScreenshotType = (
    VRScreenshotType_None = 0,
    VRScreenshotType_Mono = 1,
    VRScreenshotType_Stereo = 2,
    VRScreenshotType_Cubemap = 3,
    VRScreenshotType_MonoPanorama = 4,
    VRScreenshotType_StereoPanorama = 5
  );

  EVRScreenshotPropertyFilenames = (
    VRScreenshotPropertyFilenames_Preview = 0,
    VRScreenshotPropertyFilenames_VR = 1
  );

  EVRTrackedCameraError = (
    VRTrackedCameraError_None = 0,
    VRTrackedCameraError_OperationFailed = 100,
    VRTrackedCameraError_InvalidHandle = 101,
    VRTrackedCameraError_InvalidFrameHeaderVersion = 102,
    VRTrackedCameraError_OutOfHandles = 103,
    VRTrackedCameraError_IPCFailure = 104,
    VRTrackedCameraError_NotSupportedForThisDevice = 105,
    VRTrackedCameraError_SharedMemoryFailure = 106,
    VRTrackedCameraError_FrameBufferingFailure = 107,
    VRTrackedCameraError_StreamSetupFailure = 108,
    VRTrackedCameraError_InvalidGLTextureId = 109,
    VRTrackedCameraError_InvalidSharedTextureHandle = 110,
    VRTrackedCameraError_FailedToGetGLTextureId = 111,
    VRTrackedCameraError_SharedTextureFailure = 112,
    VRTrackedCameraError_NoFrameAvailable = 113,
    VRTrackedCameraError_InvalidArgument = 114,
    VRTrackedCameraError_InvalidFrameBufferSize = 115
  );

  EVRTrackedCameraFrameLayout = (
    EVRTrackedCameraFrameLayout_Mono = 1,
    EVRTrackedCameraFrameLayout_Stereo = 2,
    EVRTrackedCameraFrameLayout_VerticalLayout = 16,
    EVRTrackedCameraFrameLayout_HorizontalLayout = 32
  );

  EVRTrackedCameraFrameType = (
    VRTrackedCameraFrameType_Distorted = 0,
    VRTrackedCameraFrameType_Undistorted = 1,
    VRTrackedCameraFrameType_MaximumUndistorted = 2,
    MAX_CAMERA_FRAME_TYPES = 3
  );

  EVRDistortionFunctionType = (
    VRDistortionFunctionType_None = 0,
    VRDistortionFunctionType_FTheta = 1,
    VRDistortionFunctionType_Extended_FTheta = 2,
    MAX_DISTORTION_FUNCTION_TYPES = 3
  );

  EVSync = (
    VSync_None = 0,
    VSync_WaitRender = 1,
    VSync_NoWaitRender = 2
  );

  EVRMuraCorrectionMode = (
    EVRMuraCorrectionMode_Default = 0,
    EVRMuraCorrectionMode_NoCorrection = 1
  );

  Imu_OffScaleFlags = (
    OffScale_AccelX = 1,
    OffScale_AccelY = 2,
    OffScale_AccelZ = 4,
    OffScale_GyroX = 8,
    OffScale_GyroY = 16,
    OffScale_GyroZ = 32
  );

  EVRApplicationError = (
    VRApplicationError_None = 0,
    VRApplicationError_AppKeyAlreadyExists = 100,
    VRApplicationError_NoManifest = 101,
    VRApplicationError_NoApplication = 102,
    VRApplicationError_InvalidIndex = 103,
    VRApplicationError_UnknownApplication = 104,
    VRApplicationError_IPCFailed = 105,
    VRApplicationError_ApplicationAlreadyRunning = 106,
    VRApplicationError_InvalidManifest = 107,
    VRApplicationError_InvalidApplication = 108,
    VRApplicationError_LaunchFailed = 109,
    VRApplicationError_ApplicationAlreadyStarting = 110,
    VRApplicationError_LaunchInProgress = 111,
    VRApplicationError_OldApplicationQuitting = 112,
    VRApplicationError_TransitionAborted = 113,
    VRApplicationError_IsTemplate = 114,
    VRApplicationError_SteamVRIsExiting = 115,
    VRApplicationError_BufferTooSmall = 200,
    VRApplicationError_PropertyNotSet = 201,
    VRApplicationError_UnknownProperty = 202,
    VRApplicationError_InvalidParameter = 203
  );

  EVRApplicationProperty = (
    VRApplicationProperty_Name_String = 0,
    VRApplicationProperty_LaunchType_String = 11,
    VRApplicationProperty_WorkingDirectory_String = 12,
    VRApplicationProperty_BinaryPath_String = 13,
    VRApplicationProperty_Arguments_String = 14,
    VRApplicationProperty_URL_String = 15,
    VRApplicationProperty_Description_String = 50,
    VRApplicationProperty_NewsURL_String = 51,
    VRApplicationProperty_ImagePath_String = 52,
    VRApplicationProperty_Source_String = 53,
    VRApplicationProperty_ActionManifestURL_String = 54,
    VRApplicationProperty_IsDashboardOverlay_Bool = 60,
    VRApplicationProperty_IsTemplate_Bool = 61,
    VRApplicationProperty_IsInstanced_Bool = 62,
    VRApplicationProperty_IsInternal_Bool = 63,
    VRApplicationProperty_WantsCompositorPauseInStandby_Bool = 64,
    VRApplicationProperty_IsHidden_Bool = 65,
    VRApplicationProperty_LastLaunchTime_Uint64 = 70
  );

  EVRSceneApplicationState = (
    EVRSceneApplicationState_None = 0,
    EVRSceneApplicationState_Starting = 1,
    EVRSceneApplicationState_Quitting = 2,
    EVRSceneApplicationState_Running = 3,
    EVRSceneApplicationState_Waiting = 4
  );

  ChaperoneCalibrationState = (
    ChaperoneCalibrationState_OK = 1,
    ChaperoneCalibrationState_Warning = 100,
    ChaperoneCalibrationState_Warning_BaseStationMayHaveMoved = 101,
    ChaperoneCalibrationState_Warning_BaseStationRemoved = 102,
    ChaperoneCalibrationState_Warning_SeatedBoundsInvalid = 103,
    ChaperoneCalibrationState_Error = 200,
    ChaperoneCalibrationState_Error_BaseStationUninitialized = 201,
    ChaperoneCalibrationState_Error_BaseStationConflict = 202,
    ChaperoneCalibrationState_Error_PlayAreaInvalid = 203,
    ChaperoneCalibrationState_Error_CollisionBoundsInvalid = 204
  );

  EChaperoneConfigFile = (
    EChaperoneConfigFile_Live = 1,
    EChaperoneConfigFile_Temp = 2
  );

  EChaperoneImportFlags = (
    EChaperoneImport_BoundsOnly = 1
  );

  EVRCompositorError = (
    VRCompositorError_None = 0,
    VRCompositorError_RequestFailed = 1,
    VRCompositorError_IncompatibleVersion = 100,
    VRCompositorError_DoNotHaveFocus = 101,
    VRCompositorError_InvalidTexture = 102,
    VRCompositorError_IsNotSceneApplication = 103,
    VRCompositorError_TextureIsOnWrongDevice = 104,
    VRCompositorError_TextureUsesUnsupportedFormat = 105,
    VRCompositorError_SharedTexturesNotSupported = 106,
    VRCompositorError_IndexOutOfRange = 107,
    VRCompositorError_AlreadySubmitted = 108,
    VRCompositorError_InvalidBounds = 109,
    VRCompositorError_AlreadySet = 110
  );

  EVRCompositorTimingMode = (
    VRCompositorTimingMode_Implicit = 0,
    VRCompositorTimingMode_Explicit_RuntimePerformsPostPresentHandoff = 1,
    VRCompositorTimingMode_Explicit_ApplicationPerformsPostPresentHandoff = 2
  );

  VROverlayInputMethod = (
    VROverlayInputMethod_None = 0,
    VROverlayInputMethod_Mouse = 1
  );

  VROverlayTransformType = (
    VROverlayTransform_Invalid = -1,
    VROverlayTransform_Absolute = 0,
    VROverlayTransform_TrackedDeviceRelative = 1,
    VROverlayTransform_SystemOverlay = 2,
    VROverlayTransform_TrackedComponent = 3,
    VROverlayTransform_Cursor = 4,
    VROverlayTransform_DashboardTab = 5,
    VROverlayTransform_DashboardThumb = 6,
    VROverlayTransform_Mountable = 7
  );

  VROverlayFlags = (
    VROverlayFlags_NoDashboardTab = 8,
    VROverlayFlags_SendVRDiscreteScrollEvents = 64,
    VROverlayFlags_SendVRTouchpadEvents = 128,
    VROverlayFlags_ShowTouchPadScrollWheel = 256,
    VROverlayFlags_TransferOwnershipToInternalProcess = 512,
    VROverlayFlags_SideBySide_Parallel = 1024,
    VROverlayFlags_SideBySide_Crossed = 2048,
    VROverlayFlags_Panorama = 4096,
    VROverlayFlags_StereoPanorama = 8192,
    VROverlayFlags_SortWithNonSceneOverlays = 16384,
    VROverlayFlags_VisibleInDashboard = 32768,
    VROverlayFlags_MakeOverlaysInteractiveIfVisible = 65536,
    VROverlayFlags_SendVRSmoothScrollEvents = 131072,
    VROverlayFlags_ProtectedContent = 262144,
    VROverlayFlags_HideLaserIntersection = 524288,
    VROverlayFlags_WantsModalBehavior = 1048576,
    VROverlayFlags_IsPremultiplied = 2097152
  );

  VRMessageOverlayResponse = (
    VRMessageOverlayResponse_ButtonPress_0 = 0,
    VRMessageOverlayResponse_ButtonPress_1 = 1,
    VRMessageOverlayResponse_ButtonPress_2 = 2,
    VRMessageOverlayResponse_ButtonPress_3 = 3,
    VRMessageOverlayResponse_CouldntFindSystemOverlay = 4,
    VRMessageOverlayResponse_CouldntFindOrCreateClientOverlay = 5,
    VRMessageOverlayResponse_ApplicationQuit = 6
  );

  EGamepadTextInputMode = (
    k_EGamepadTextInputModeNormal = 0,
    k_EGamepadTextInputModePassword = 1,
    k_EGamepadTextInputModeSubmit = 2
  );

  EGamepadTextInputLineMode = (
    k_EGamepadTextInputLineModeSingleLine = 0,
    k_EGamepadTextInputLineModeMultipleLines = 1
  );

  EVROverlayIntersectionMaskPrimitiveType = (
    OverlayIntersectionPrimitiveType_Rectangle = 0,
    OverlayIntersectionPrimitiveType_Circle = 1
  );

  EKeyboardFlags = (
    KeyboardFlag_Minimal = 1,
    KeyboardFlag_Modal = 2
  );

  EDeviceType = (
    DeviceType_Invalid = -1,
    DeviceType_DirectX11 = 0,
    DeviceType_Vulkan = 1
  );

  HeadsetViewMode_t = (
    HeadsetViewMode_Left = 0,
    HeadsetViewMode_Right = 1,
    HeadsetViewMode_Both = 2
  );

  EVRRenderModelError = (
    VRRenderModelError_None = 0,
    VRRenderModelError_Loading = 100,
    VRRenderModelError_NotSupported = 200,
    VRRenderModelError_InvalidArg = 300,
    VRRenderModelError_InvalidModel = 301,
    VRRenderModelError_NoShapes = 302,
    VRRenderModelError_MultipleShapes = 303,
    VRRenderModelError_TooManyVertices = 304,
    VRRenderModelError_MultipleTextures = 305,
    VRRenderModelError_BufferTooSmall = 306,
    VRRenderModelError_NotEnoughNormals = 307,
    VRRenderModelError_NotEnoughTexCoords = 308,
    VRRenderModelError_InvalidTexture = 400
  );

  EVRRenderModelTextureFormat = (
    VRRenderModelTextureFormat_RGBA8_SRGB = 0,
    VRRenderModelTextureFormat_BC2 = 1,
    VRRenderModelTextureFormat_BC4 = 2,
    VRRenderModelTextureFormat_BC7 = 3,
    VRRenderModelTextureFormat_BC7_SRGB = 4
  );

  EVRNotificationType = (
    EVRNotificationType_Transient = 0,
    EVRNotificationType_Persistent = 1,
    EVRNotificationType_Transient_SystemWithUserValue = 2
  );

  EVRNotificationStyle = (
    EVRNotificationStyle_None = 0,
    EVRNotificationStyle_Application = 100,
    EVRNotificationStyle_Contact_Disabled = 200,
    EVRNotificationStyle_Contact_Enabled = 201,
    EVRNotificationStyle_Contact_Active = 202
  );

  EVRSettingsError = (
    VRSettingsError_None = 0,
    VRSettingsError_IPCFailed = 1,
    VRSettingsError_WriteFailed = 2,
    VRSettingsError_ReadFailed = 3,
    VRSettingsError_JsonParseFailed = 4,
    VRSettingsError_UnsetSettingHasNoDefault = 5
  );

  EVRScreenshotError = (
    VRScreenshotError_None = 0,
    VRScreenshotError_RequestFailed = 1,
    VRScreenshotError_IncompatibleVersion = 100,
    VRScreenshotError_NotFound = 101,
    VRScreenshotError_BufferTooSmall = 102,
    VRScreenshotError_ScreenshotAlreadyInProgress = 108
  );

  EVRSkeletalTransformSpace = (
    VRSkeletalTransformSpace_Model = 0,
    VRSkeletalTransformSpace_Parent = 1
  );

  EVRSkeletalReferencePose = (
    VRSkeletalReferencePose_BindPose = 0,
    VRSkeletalReferencePose_OpenHand = 1,
    VRSkeletalReferencePose_Fist = 2,
    VRSkeletalReferencePose_GripLimit = 3
  );

  EVRFinger = (
    VRFinger_Thumb = 0,
    VRFinger_Index = 1,
    VRFinger_Middle = 2,
    VRFinger_Ring = 3,
    VRFinger_Pinky = 4,
    VRFinger_Count = 5
  );

  EVRFingerSplay = (
    VRFingerSplay_Thumb_Index = 0,
    VRFingerSplay_Index_Middle = 1,
    VRFingerSplay_Middle_Ring = 2,
    VRFingerSplay_Ring_Pinky = 3,
    VRFingerSplay_Count = 4
  );

  EVRSummaryType = (
    VRSummaryType_FromAnimation = 0,
    VRSummaryType_FromDevice = 1
  );

  EVRInputFilterCancelType = (
    VRInputFilterCancel_Timers = 0,
    VRInputFilterCancel_Momentum = 1
  );

  EVRInputStringBits = (
    VRInputString_Hand = 1,
    VRInputString_ControllerType = 2,
    VRInputString_InputSource = 4,
    VRInputString_All = -1
  );

  EIOBufferError = (
    IOBuffer_Success = 0,
    IOBuffer_OperationFailed = 100,
    IOBuffer_InvalidHandle = 101,
    IOBuffer_InvalidArgument = 102,
    IOBuffer_PathExists = 103,
    IOBuffer_PathDoesNotExist = 104,
    IOBuffer_Permission = 105
  );

  EIOBufferMode = (
    IOBufferMode_Read = 1,
    IOBufferMode_Write = 2,
    IOBufferMode_Create = 512
  );

  EVRDebugError = (
    VRDebugError_Success = 0,
    VRDebugError_BadParameter = 1
  );

  EPropertyWriteType = (
    PropertyWrite_Set = 0,
    PropertyWrite_Erase = 1,
    PropertyWrite_SetError = 2
  );

  EBlockQueueError = (
    BlockQueueError_None = 0,
    BlockQueueError_QueueAlreadyExists = 1,
    BlockQueueError_QueueNotFound = 2,
    BlockQueueError_BlockNotAvailable = 3,
    BlockQueueError_InvalidHandle = 4,
    BlockQueueError_InvalidParam = 5,
    BlockQueueError_ParamMismatch = 6,
    BlockQueueError_InternalError = 7,
    BlockQueueError_AlreadyInitialized = 8,
    BlockQueueError_OperationIsServerOnly = 9,
    BlockQueueError_TooManyConnections = 10
  );

  EBlockQueueReadType = (
    BlockQueueRead_Latest = 0,
    BlockQueueRead_New = 1,
    BlockQueueRead_Next = 2
  );



  TFloat3x3 = array [0..2, 0..2] of cfloat;
  TFloat3x4 = array [0..2, 0..3] of cfloat;
  TFloat4x4 = array [0..3, 0..3] of cfloat;
  TFloat2 = array [0..1] of cfloat;
  TFloat3 = array [0..2] of cfloat;
  TFloat4 = array [0..3] of cfloat;
  TFloat5 = array [0..4] of cfloat;
  TDouble3x3 = array [0..2, 0..2] of cfloat;
  TDouble3x4 = array [0..2, 0..3] of cdouble;
  TDouble4x4 = array [0..3, 0..3] of cfloat;
  TDouble2 = array [0..1] of cfloat;
  TDouble3 = array [0..2] of cfloat;
  TDouble4 = array [0..3] of cfloat;
  TDouble5 = array [0..4] of cfloat;
  TChar8 = array [0..7] of Char;
  TChar32 = array [0..31] of Char;
  TChar128 = array [0..127] of Char;
  UnknownPointer = Pointer;
  SpatialAnchorHandle_t = cuint32;
  glSharedTextureHandle_t = Pointer {void};
  glInt_t = cint32;
  glUInt_t = cuint32;
  SharedTextureHandle_t = cuint64;
  DriverId_t = cuint32;
  TrackedDeviceIndex_t = cuint32;
  WebConsoleHandle_t = cuint64;
  PropertyContainerHandle_t = cuint64;
  PropertyTypeTag_t = cuint32;
  DriverHandle_t = PropertyContainerHandle_t;
  VRActionHandle_t = cuint64;
  VRActionSetHandle_t = cuint64;
  VRInputValueHandle_t = cuint64;
  VREvent_Data_t = packed record
    TODO: Integer;
  end;
  VRComponentProperties = cuint32;

  VRControllerAxis_t = record
    x: cfloat;
    y: cfloat;
  end;
  PVRControllerAxis_t = ^VRControllerAxis_t;
  TVRControllerAxis_t5 = array [0..4] of VRControllerAxis_t;

  VRControllerState001_t = record
    unPacketNum: cuint32;
    ulButtonPressed: cuint64;
    ulButtonTouched: cuint64;
    rAxis: TVRControllerAxis_t5;
  end;
  PVRControllerState001_t = ^VRControllerState001_t;
  VRControllerState_t = VRControllerState001_t;
  VROverlayHandle_t = cuint64;
  BoneIndex_t = cint32;
  TrackedCameraHandle_t = cuint64;
  ScreenshotHandle_t = cuint32;
  VROverlayIntersectionMaskPrimitive_Data_t = packed record
    TODO: Integer;
  end;
  TextureID_t = cint32;
  VRNotificationId = cuint32;
  IOBufferHandle_t = cuint64;
  VrProfilerEventHandle_t = cuint64;
  HmdError = EVRInitError;
  Hmd_Eye = EVREye;
  ColorSpace = EColorSpace;
  HmdTrackingResult = ETrackingResult;
  TrackedDeviceClass = ETrackedDeviceClass;
  TrackingUniverseOrigin = ETrackingUniverseOrigin;
  TrackedDeviceProperty = ETrackedDeviceProperty;
  TrackedPropertyError = ETrackedPropertyError;
  VRSubmitFlags_t = EVRSubmitFlags;
  VRState_t = EVRState;
  CollisionBoundsStyle_t = ECollisionBoundsStyle;
  VROverlayError = EVROverlayError;
  VRFirmwareError = EVRFirmwareError;
  VRCompositorError = EVRCompositorError;
  VRScreenshotsError = EVRScreenshotError;
  PathHandle_t = cuint64;


  HmdMatrix34_t = record
    m: TFloat3x4;
  end;
  PHmdMatrix34_t = ^HmdMatrix34_t;

  HmdMatrix33_t = record
    m: TFloat3x3;
  end;
  PHmdMatrix33_t = ^HmdMatrix33_t;

  HmdMatrix44_t = record
    m: TFloat4x4;
  end;
  PHmdMatrix44_t = ^HmdMatrix44_t;

  HmdVector3_t = record
    v: TFloat3;
  end;
  PHmdVector3_t = ^HmdVector3_t;
  THmdVector3_t4 = array [0..3] of HmdVector3_t;

  HmdVector4_t = record
    v: TFloat4;
  end;
  PHmdVector4_t = ^HmdVector4_t;

  HmdVector3d_t = record
    v: TDouble3;
  end;
  PHmdVector3d_t = ^HmdVector3d_t;

  HmdVector2_t = record
    v: TFloat2;
  end;
  PHmdVector2_t = ^HmdVector2_t;

  HmdQuaternion_t = record
    w: cdouble;
    x: cdouble;
    y: cdouble;
    z: cdouble;
  end;
  PHmdQuaternion_t = ^HmdQuaternion_t;

  HmdQuaternionf_t = record
    w: cfloat;
    x: cfloat;
    y: cfloat;
    z: cfloat;
  end;
  PHmdQuaternionf_t = ^HmdQuaternionf_t;

  HmdColor_t = record
    r: cfloat;
    g: cfloat;
    b: cfloat;
    a: cfloat;
  end;
  PHmdColor_t = ^HmdColor_t;

  HmdQuad_t = record
    vCorners: THmdVector3_t4;
  end;
  PHmdQuad_t = ^HmdQuad_t;

  HmdRect2_t = record
    vTopLeft: HmdVector2_t;
    vBottomRight: HmdVector2_t;
  end;
  PHmdRect2_t = ^HmdRect2_t;

  DistortionCoordinates_t = record
    rfRed: TFloat2;
    rfGreen: TFloat2;
    rfBlue: TFloat2;
  end;
  PDistortionCoordinates_t = ^DistortionCoordinates_t;

  Texture_t = record
    handle: Pointer;
    eType: ETextureType;
    eColorSpace: EColorSpace;
  end;
  PTexture_t = ^Texture_t;

  TrackedDevicePose_t = record
    mDeviceToAbsoluteTracking: HmdMatrix34_t;
    vVelocity: HmdVector3_t;
    vAngularVelocity: HmdVector3_t;
    eTrackingResult: ETrackingResult;
    bPoseIsValid: cbool;
    bDeviceIsConnected: cbool;
  end;
  PTrackedDevicePose_t = ^TrackedDevicePose_t;

  VRTextureBounds_t = record
    uMin: cfloat;
    vMin: cfloat;
    uMax: cfloat;
    vMax: cfloat;
  end;
  PVRTextureBounds_t = ^VRTextureBounds_t;

  VRTextureWithPose_t = record
    mDeviceToAbsoluteTracking: HmdMatrix34_t;
  end;
  PVRTextureWithPose_t = ^VRTextureWithPose_t;

  VRTextureDepthInfo_t = record
    handle: Pointer;
    mProjection: HmdMatrix44_t;
    vRange: HmdVector2_t;
  end;
  PVRTextureDepthInfo_t = ^VRTextureDepthInfo_t;

  VRTextureWithDepth_t = record
    depth: VRTextureDepthInfo_t;
  end;
  PVRTextureWithDepth_t = ^VRTextureWithDepth_t;

  VRTextureWithPoseAndDepth_t = record
    depth: VRTextureDepthInfo_t;
  end;
  PVRTextureWithPoseAndDepth_t = ^VRTextureWithPoseAndDepth_t;

  VRVulkanTextureData_t = record
    m_nImage: cuint64;
    m_pDevice: Pointer {VkDevice_T};
    m_pPhysicalDevice: Pointer {VkPhysicalDevice_T};
    m_pInstance: Pointer {VkInstance_T};
    m_pQueue: Pointer {VkQueue_T};
    m_nQueueFamilyIndex: cuint32;
    m_nWidth: cuint32;
    m_nHeight: cuint32;
    m_nFormat: cuint32;
    m_nSampleCount: cuint32;
  end;
  PVRVulkanTextureData_t = ^VRVulkanTextureData_t;

  VRVulkanTextureArrayData_t = record
    m_unArrayIndex: cuint32;
    m_unArraySize: cuint32;
  end;
  PVRVulkanTextureArrayData_t = ^VRVulkanTextureArrayData_t;

  D3D12TextureData_t = record
    m_pResource: Pointer {ID3D12Resource};
    m_pCommandQueue: Pointer {ID3D12CommandQueue};
    m_nNodeMask: cuint32;
  end;
  PD3D12TextureData_t = ^D3D12TextureData_t;

  VREvent_Controller_t = record
    button: cuint32;
  end;
  PVREvent_Controller_t = ^VREvent_Controller_t;

  VREvent_Mouse_t = record
    x: cfloat;
    y: cfloat;
    button: cuint32;
  end;
  PVREvent_Mouse_t = ^VREvent_Mouse_t;

  VREvent_Scroll_t = record
    xdelta: cfloat;
    ydelta: cfloat;
    unused: cuint32;
    viewportscale: cfloat;
  end;
  PVREvent_Scroll_t = ^VREvent_Scroll_t;

  VREvent_TouchPadMove_t = record
    bFingerDown: cbool;
    flSecondsFingerDown: cfloat;
    fValueXFirst: cfloat;
    fValueYFirst: cfloat;
    fValueXRaw: cfloat;
    fValueYRaw: cfloat;
  end;
  PVREvent_TouchPadMove_t = ^VREvent_TouchPadMove_t;

  VREvent_Notification_t = record
    ulUserValue: cuint64;
    notificationId: cuint32;
  end;
  PVREvent_Notification_t = ^VREvent_Notification_t;

  VREvent_Process_t = record
    pid: cuint32;
    oldPid: cuint32;
    bForced: cbool;
    bConnectionLost: cbool;
  end;
  PVREvent_Process_t = ^VREvent_Process_t;

  VREvent_Overlay_t = record
    overlayHandle: cuint64;
    devicePath: cuint64;
  end;
  PVREvent_Overlay_t = ^VREvent_Overlay_t;

  VREvent_Status_t = record
    statusState: cuint32;
  end;
  PVREvent_Status_t = ^VREvent_Status_t;

  VREvent_Keyboard_t = record
    cNewInput: TChar8;
    uUserValue: cuint64;
  end;
  PVREvent_Keyboard_t = ^VREvent_Keyboard_t;

  VREvent_Ipd_t = record
    ipdMeters: cfloat;
  end;
  PVREvent_Ipd_t = ^VREvent_Ipd_t;

  VREvent_Chaperone_t = record
    m_nPreviousUniverse: cuint64;
    m_nCurrentUniverse: cuint64;
  end;
  PVREvent_Chaperone_t = ^VREvent_Chaperone_t;

  VREvent_Reserved_t = record
    reserved0: cuint64;
    reserved1: cuint64;
    reserved2: cuint64;
    reserved3: cuint64;
    reserved4: cuint64;
    reserved5: cuint64;
  end;
  PVREvent_Reserved_t = ^VREvent_Reserved_t;

  VREvent_PerformanceTest_t = record
    m_nFidelityLevel: cuint32;
  end;
  PVREvent_PerformanceTest_t = ^VREvent_PerformanceTest_t;

  VREvent_SeatedZeroPoseReset_t = record
    bResetBySystemMenu: cbool;
  end;
  PVREvent_SeatedZeroPoseReset_t = ^VREvent_SeatedZeroPoseReset_t;

  VREvent_Screenshot_t = record
    handle: cuint32;
    type_: cuint32;
  end;
  PVREvent_Screenshot_t = ^VREvent_Screenshot_t;

  VREvent_ScreenshotProgress_t = record
    progress: cfloat;
  end;
  PVREvent_ScreenshotProgress_t = ^VREvent_ScreenshotProgress_t;

  VREvent_ApplicationLaunch_t = record
    pid: cuint32;
    unArgsHandle: cuint32;
  end;
  PVREvent_ApplicationLaunch_t = ^VREvent_ApplicationLaunch_t;

  VREvent_EditingCameraSurface_t = record
    overlayHandle: cuint64;
    nVisualMode: cuint32;
  end;
  PVREvent_EditingCameraSurface_t = ^VREvent_EditingCameraSurface_t;

  VREvent_MessageOverlay_t = record
    unVRMessageOverlayResponse: cuint32;
  end;
  PVREvent_MessageOverlay_t = ^VREvent_MessageOverlay_t;

  VREvent_Property_t = record
    container: PropertyContainerHandle_t;
    prop: ETrackedDeviceProperty;
  end;
  PVREvent_Property_t = ^VREvent_Property_t;

  VREvent_HapticVibration_t = record
    containerHandle: cuint64;
    componentHandle: cuint64;
    fDurationSeconds: cfloat;
    fFrequency: cfloat;
    fAmplitude: cfloat;
  end;
  PVREvent_HapticVibration_t = ^VREvent_HapticVibration_t;

  VREvent_WebConsole_t = record
    webConsoleHandle: WebConsoleHandle_t;
  end;
  PVREvent_WebConsole_t = ^VREvent_WebConsole_t;

  VREvent_InputBindingLoad_t = record
    ulAppContainer: PropertyContainerHandle_t;
    pathMessage: cuint64;
    pathUrl: cuint64;
    pathControllerType: cuint64;
  end;
  PVREvent_InputBindingLoad_t = ^VREvent_InputBindingLoad_t;

  VREvent_InputActionManifestLoad_t = record
    pathAppKey: cuint64;
    pathMessage: cuint64;
    pathMessageParam: cuint64;
    pathManifestPath: cuint64;
  end;
  PVREvent_InputActionManifestLoad_t = ^VREvent_InputActionManifestLoad_t;

  VREvent_SpatialAnchor_t = record
    unHandle: SpatialAnchorHandle_t;
  end;
  PVREvent_SpatialAnchor_t = ^VREvent_SpatialAnchor_t;

  VREvent_ProgressUpdate_t = record
    ulApplicationPropertyContainer: cuint64;
    pathDevice: cuint64;
    pathInputSource: cuint64;
    pathProgressAction: cuint64;
    pathIcon: cuint64;
    fProgress: cfloat;
  end;
  PVREvent_ProgressUpdate_t = ^VREvent_ProgressUpdate_t;

  VREvent_ShowUI_t = record
    eType: EShowUIType;
  end;
  PVREvent_ShowUI_t = ^VREvent_ShowUI_t;

  VREvent_ShowDevTools_t = record
    nBrowserIdentifier: cint32;
  end;
  PVREvent_ShowDevTools_t = ^VREvent_ShowDevTools_t;

  VREvent_HDCPError_t = record
    eCode: EHDCPError;
  end;
  PVREvent_HDCPError_t = ^VREvent_HDCPError_t;

  anonymous = record
    reserved: VREvent_Reserved_t;
    controller: VREvent_Controller_t;
    mouse: VREvent_Mouse_t;
    scroll: VREvent_Scroll_t;
    process: VREvent_Process_t;
    notification: VREvent_Notification_t;
    overlay: VREvent_Overlay_t;
    status: VREvent_Status_t;
    keyboard: VREvent_Keyboard_t;
    ipd: VREvent_Ipd_t;
    chaperone: VREvent_Chaperone_t;
    performanceTest: VREvent_PerformanceTest_t;
    touchPadMove: VREvent_TouchPadMove_t;
    seatedZeroPoseReset: VREvent_SeatedZeroPoseReset_t;
    screenshot: VREvent_Screenshot_t;
    screenshotProgress: VREvent_ScreenshotProgress_t;
    applicationLaunch: VREvent_ApplicationLaunch_t;
    cameraSurface: VREvent_EditingCameraSurface_t;
    messageOverlay: VREvent_MessageOverlay_t;
    property_: VREvent_Property_t;
    hapticVibration: VREvent_HapticVibration_t;
    webConsole: VREvent_WebConsole_t;
    inputBinding: VREvent_InputBindingLoad_t;
    actionManifest: VREvent_InputActionManifestLoad_t;
    spatialAnchor: VREvent_SpatialAnchor_t;
    progressUpdate: VREvent_ProgressUpdate_t;
    showUi: VREvent_ShowUI_t;
    showDevTools: VREvent_ShowDevTools_t;
    hdcpError: VREvent_HDCPError_t;
  end;
  Panonymous = ^anonymous;

  VREvent_t = record
    eventType: cuint32;
    trackedDeviceIndex: TrackedDeviceIndex_t;
    eventAgeSeconds: cfloat;
    data: VREvent_Data_t;
  end;
  PVREvent_t = ^VREvent_t;

  RenderModel_ComponentState_t = record
    mTrackingToComponentRenderModel: HmdMatrix34_t;
    mTrackingToComponentLocal: HmdMatrix34_t;
    uProperties: VRComponentProperties;
  end;
  PRenderModel_ComponentState_t = ^RenderModel_ComponentState_t;

  HiddenAreaMesh_t = record
    pVertexData: Pointer {HmdVector2_t};
    unTriangleCount: cuint32;
  end;
  PHiddenAreaMesh_t = ^HiddenAreaMesh_t;

  VRBoneTransform_t = record
    position: HmdVector4_t;
    orientation: HmdQuaternionf_t;
  end;
  PVRBoneTransform_t = ^VRBoneTransform_t;

  CameraVideoStreamFrameHeader_t = record
    eFrameType: EVRTrackedCameraFrameType;
    nWidth: cuint32;
    nHeight: cuint32;
    nBytesPerPixel: cuint32;
    nFrameSequence: cuint32;
    trackedDevicePose: TrackedDevicePose_t;
    ulFrameExposureTime: cuint64;
  end;
  PCameraVideoStreamFrameHeader_t = ^CameraVideoStreamFrameHeader_t;

  Compositor_FrameTiming = record
    m_nSize: cuint32;
    m_nFrameIndex: cuint32;
    m_nNumFramePresents: cuint32;
    m_nNumMisPresented: cuint32;
    m_nNumDroppedFrames: cuint32;
    m_nReprojectionFlags: cuint32;
    m_flSystemTimeInSeconds: cdouble;
    m_flPreSubmitGpuMs: cfloat;
    m_flPostSubmitGpuMs: cfloat;
    m_flTotalRenderGpuMs: cfloat;
    m_flCompositorRenderGpuMs: cfloat;
    m_flCompositorRenderCpuMs: cfloat;
    m_flCompositorIdleCpuMs: cfloat;
    m_flClientFrameIntervalMs: cfloat;
    m_flPresentCallCpuMs: cfloat;
    m_flWaitForPresentCpuMs: cfloat;
    m_flSubmitFrameMs: cfloat;
    m_flWaitGetPosesCalledMs: cfloat;
    m_flNewPosesReadyMs: cfloat;
    m_flNewFrameReadyMs: cfloat;
    m_flCompositorUpdateStartMs: cfloat;
    m_flCompositorUpdateEndMs: cfloat;
    m_flCompositorRenderStartMs: cfloat;
    m_HmdPose: TrackedDevicePose_t;
    m_nNumVSyncsReadyForUse: cuint32;
    m_nNumVSyncsToFirstView: cuint32;
  end;
  PCompositor_FrameTiming = ^Compositor_FrameTiming;

  Compositor_BenchmarkResults = record
    m_flMegaPixelsPerSecond: cfloat;
    m_flHmdRecommendedMegaPixelsPerSecond: cfloat;
  end;
  PCompositor_BenchmarkResults = ^Compositor_BenchmarkResults;

  DriverDirectMode_FrameTiming = record
    m_nSize: cuint32;
    m_nNumFramePresents: cuint32;
    m_nNumMisPresented: cuint32;
    m_nNumDroppedFrames: cuint32;
    m_nReprojectionFlags: cuint32;
  end;
  PDriverDirectMode_FrameTiming = ^DriverDirectMode_FrameTiming;

  ImuSample_t = record
    fSampleTime: cdouble;
    vAccel: HmdVector3d_t;
    vGyro: HmdVector3d_t;
    unOffScaleFlags: cuint32;
  end;
  PImuSample_t = ^ImuSample_t;

  AppOverrideKeys_t = record
    pchKey: PChar;
    pchValue: PChar;
  end;
  PAppOverrideKeys_t = ^AppOverrideKeys_t;

  Compositor_CumulativeStats = record
    m_nPid: cuint32;
    m_nNumFramePresents: cuint32;
    m_nNumDroppedFrames: cuint32;
    m_nNumReprojectedFrames: cuint32;
    m_nNumFramePresentsOnStartup: cuint32;
    m_nNumDroppedFramesOnStartup: cuint32;
    m_nNumReprojectedFramesOnStartup: cuint32;
    m_nNumLoading: cuint32;
    m_nNumFramePresentsLoading: cuint32;
    m_nNumDroppedFramesLoading: cuint32;
    m_nNumReprojectedFramesLoading: cuint32;
    m_nNumTimedOut: cuint32;
    m_nNumFramePresentsTimedOut: cuint32;
    m_nNumDroppedFramesTimedOut: cuint32;
    m_nNumReprojectedFramesTimedOut: cuint32;
  end;
  PCompositor_CumulativeStats = ^Compositor_CumulativeStats;

  Compositor_StageRenderSettings = record
    m_PrimaryColor: HmdColor_t;
    m_SecondaryColor: HmdColor_t;
    m_flVignetteInnerRadius: cfloat;
    m_flVignetteOuterRadius: cfloat;
    m_flFresnelStrength: cfloat;
    m_bBackfaceCulling: cbool;
    m_bGreyscale: cbool;
    m_bWireframe: cbool;
  end;
  PCompositor_StageRenderSettings = ^Compositor_StageRenderSettings;

  VROverlayIntersectionParams_t = record
    vSource: HmdVector3_t;
    vDirection: HmdVector3_t;
    eOrigin: ETrackingUniverseOrigin;
  end;
  PVROverlayIntersectionParams_t = ^VROverlayIntersectionParams_t;

  VROverlayIntersectionResults_t = record
    vPoint: HmdVector3_t;
    vNormal: HmdVector3_t;
    vUVs: HmdVector2_t;
    fDistance: cfloat;
  end;
  PVROverlayIntersectionResults_t = ^VROverlayIntersectionResults_t;

  IntersectionMaskRectangle_t = record
    m_flTopLeftX: cfloat;
    m_flTopLeftY: cfloat;
    m_flWidth: cfloat;
    m_flHeight: cfloat;
  end;
  PIntersectionMaskRectangle_t = ^IntersectionMaskRectangle_t;

  IntersectionMaskCircle_t = record
    m_flCenterX: cfloat;
    m_flCenterY: cfloat;
    m_flRadius: cfloat;
  end;
  PIntersectionMaskCircle_t = ^IntersectionMaskCircle_t;

  anonymous2 = record
    m_Rectangle: IntersectionMaskRectangle_t;
    m_Circle: IntersectionMaskCircle_t;
  end;
  Panonymous2 = ^anonymous2;

  VROverlayIntersectionMaskPrimitive_t = record
    m_nPrimitiveType: EVROverlayIntersectionMaskPrimitiveType;
    m_Primitive: VROverlayIntersectionMaskPrimitive_Data_t;
  end;
  PVROverlayIntersectionMaskPrimitive_t = ^VROverlayIntersectionMaskPrimitive_t;

  VROverlayView_t = record
    overlayHandle: VROverlayHandle_t;
    texture: Texture_t;
    textureBounds: VRTextureBounds_t;
  end;
  PVROverlayView_t = ^VROverlayView_t;

  VRVulkanDevice_t = record
    m_pInstance: Pointer {VkInstance_T};
    m_pDevice: Pointer {VkDevice_T};
    m_pPhysicalDevice: Pointer {VkPhysicalDevice_T};
    m_pQueue: Pointer {VkQueue_T};
    m_uQueueFamilyIndex: cuint32;
  end;
  PVRVulkanDevice_t = ^VRVulkanDevice_t;

  VRNativeDevice_t = record
    handle: Pointer;
    eType: EDeviceType;
  end;
  PVRNativeDevice_t = ^VRNativeDevice_t;

  RenderModel_Vertex_t = record
    vPosition: HmdVector3_t;
    vNormal: HmdVector3_t;
    rfTextureCoord: TFloat2;
  end;
  PRenderModel_Vertex_t = ^RenderModel_Vertex_t;

  RenderModel_TextureMap_t = record
    unWidth: cuint16;
    unHeight: cuint16;
    rubTextureMapData: Pointer {uint8_t};
    format: EVRRenderModelTextureFormat;
  end;
  PRenderModel_TextureMap_t = ^RenderModel_TextureMap_t;

  RenderModel_t = record
    rVertexData: Pointer {RenderModel_Vertex_t};
    unVertexCount: cuint32;
    rIndexData: Pointer {uint16_t};
    unTriangleCount: cuint32;
    diffuseTextureId: TextureID_t;
  end;
  PRenderModel_t = ^RenderModel_t;

  RenderModel_ControllerMode_State_t = record
    bScrollWheelVisible: cbool;
  end;
  PRenderModel_ControllerMode_State_t = ^RenderModel_ControllerMode_State_t;

  NotificationBitmap_t = record
    m_pImageData: Pointer;
    m_nWidth: cint32;
    m_nHeight: cint32;
    m_nBytesPerPixel: cint32;
  end;
  PNotificationBitmap_t = ^NotificationBitmap_t;

  CVRSettingHelper = record
    m_pSettings: Pointer {FnTable_IVRSettings};
  end;
  PCVRSettingHelper = ^CVRSettingHelper;

  InputAnalogActionData_t = record
    bActive: cbool;
    activeOrigin: VRInputValueHandle_t;
    x: cfloat;
    y: cfloat;
    z: cfloat;
    deltaX: cfloat;
    deltaY: cfloat;
    deltaZ: cfloat;
    fUpdateTime: cfloat;
  end;
  PInputAnalogActionData_t = ^InputAnalogActionData_t;

  InputDigitalActionData_t = record
    bActive: cbool;
    activeOrigin: VRInputValueHandle_t;
    bState: cbool;
    bChanged: cbool;
    fUpdateTime: cfloat;
  end;
  PInputDigitalActionData_t = ^InputDigitalActionData_t;

  InputPoseActionData_t = record
    bActive: cbool;
    activeOrigin: VRInputValueHandle_t;
    pose: TrackedDevicePose_t;
  end;
  PInputPoseActionData_t = ^InputPoseActionData_t;

  InputSkeletalActionData_t = record
    bActive: cbool;
    activeOrigin: VRInputValueHandle_t;
  end;
  PInputSkeletalActionData_t = ^InputSkeletalActionData_t;

  InputOriginInfo_t = record
    devicePath: VRInputValueHandle_t;
    trackedDeviceIndex: TrackedDeviceIndex_t;
    rchRenderModelComponentName: TChar128;
  end;
  PInputOriginInfo_t = ^InputOriginInfo_t;

  InputBindingInfo_t = record
    rchDevicePathName: TChar128;
    rchInputPathName: TChar128;
    rchModeName: TChar128;
    rchSlotName: TChar128;
    rchInputSourceType: TChar32;
  end;
  PInputBindingInfo_t = ^InputBindingInfo_t;

  VRActiveActionSet_t = record
    ulActionSet: VRActionSetHandle_t;
    ulRestrictedToDevice: VRInputValueHandle_t;
    ulSecondaryActionSet: VRActionSetHandle_t;
    unPadding: cuint32;
    nPriority: cint32;
  end;
  PVRActiveActionSet_t = ^VRActiveActionSet_t;

  VRSkeletalSummaryData_t = record
    flFingerCurl: TFloat5;
    flFingerSplay: TFloat4;
  end;
  PVRSkeletalSummaryData_t = ^VRSkeletalSummaryData_t;

  SpatialAnchorPose_t = record
    mAnchorToAbsoluteTracking: HmdMatrix34_t;
  end;
  PSpatialAnchorPose_t = ^SpatialAnchorPose_t;

  COpenVRContext = record
    m_pVRSystem: Pointer {FnTable_IVRSystem};
    m_pVRChaperone: Pointer {FnTable_IVRChaperone};
    m_pVRChaperoneSetup: Pointer {FnTable_IVRChaperoneSetup};
    m_pVRCompositor: Pointer {FnTable_IVRCompositor};
    m_pVRHeadsetView: Pointer {FnTable_IVRHeadsetView};
    m_pVROverlay: Pointer {FnTable_IVROverlay};
    m_pVROverlayView: Pointer {FnTable_IVROverlayView};
    m_pVRResources: Pointer {FnTable_IVRResources};
    m_pVRRenderModels: Pointer {FnTable_IVRRenderModels};
    m_pVRExtendedDisplay: Pointer {FnTable_IVRExtendedDisplay};
    m_pVRSettings: Pointer {FnTable_IVRSettings};
    m_pVRApplications: Pointer {FnTable_IVRApplications};
    m_pVRTrackedCamera: Pointer {FnTable_IVRTrackedCamera};
    m_pVRScreenshots: Pointer {FnTable_IVRScreenshots};
    m_pVRDriverManager: Pointer {FnTable_IVRDriverManager};
    m_pVRInput: Pointer {FnTable_IVRInput};
    m_pVRIOBuffer: Pointer {FnTable_IVRIOBuffer};
    m_pVRSpatialAnchors: Pointer {FnTable_IVRSpatialAnchors};
    m_pVRDebug: Pointer {FnTable_IVRDebug};
    m_pVRNotifications: Pointer {FnTable_IVRNotifications};
  end;
  PCOpenVRContext = ^COpenVRContext;

  PropertyWrite_t = record
    prop: ETrackedDeviceProperty;
    writeType: EPropertyWriteType;
    eSetError: ETrackedPropertyError;
    pvBuffer: Pointer;
    unBufferSize: cuint32;
    unTag: PropertyTypeTag_t;
    eError: ETrackedPropertyError;
  end;
  PPropertyWrite_t = ^PropertyWrite_t;

  PropertyRead_t = record
    prop: ETrackedDeviceProperty;
    pvBuffer: Pointer;
    unBufferSize: cuint32;
    unTag: PropertyTypeTag_t;
    unRequiredBufferSize: cuint32;
    eError: ETrackedPropertyError;
  end;
  PPropertyRead_t = ^PropertyRead_t;

  CVRPropertyHelpers = record
    m_pProperties: Pointer {FnTable_IVRProperties};
  end;
  PCVRPropertyHelpers = ^CVRPropertyHelpers;

  PathWrite_t = record
    ulPath: PathHandle_t;
    writeType: EPropertyWriteType;
    eSetError: ETrackedPropertyError;
    pvBuffer: Pointer;
    unBufferSize: cuint32;
    unTag: PropertyTypeTag_t;
    eError: ETrackedPropertyError;
    pszPath: PChar;
  end;
  PPathWrite_t = ^PathWrite_t;

  PathRead_t = record
    ulPath: PathHandle_t;
    pvBuffer: Pointer;
    unBufferSize: cuint32;
    unTag: PropertyTypeTag_t;
    unRequiredBufferSize: cuint32;
    eError: ETrackedPropertyError;
    pszPath: PChar;
  end;
  PPathRead_t = ^PathRead_t;


const
  k_nDriverNone: cuint32 = 4294967295;
  k_unMaxDriverDebugResponseSize: cuint32 = 32768;
  k_unTrackedDeviceIndex_Hmd: cuint32 = 0;
  k_unMaxTrackedDeviceCount: cuint32 = 64;
  k_unTrackedDeviceIndexOther: cuint32 = 4294967294;
  k_unTrackedDeviceIndexInvalid: cuint32 = 4294967295;
  k_ulInvalidPropertyContainer: PropertyContainerHandle_t = 0;
  k_unInvalidPropertyTag: PropertyTypeTag_t = 0;
  k_ulInvalidDriverHandle: PropertyContainerHandle_t = 0;
  k_unFloatPropertyTag: PropertyTypeTag_t = 1;
  k_unInt32PropertyTag: PropertyTypeTag_t = 2;
  k_unUint64PropertyTag: PropertyTypeTag_t = 3;
  k_unBoolPropertyTag: PropertyTypeTag_t = 4;
  k_unStringPropertyTag: PropertyTypeTag_t = 5;
  k_unErrorPropertyTag: PropertyTypeTag_t = 6;
  k_unDoublePropertyTag: PropertyTypeTag_t = 7;
  k_unHmdMatrix34PropertyTag: PropertyTypeTag_t = 20;
  k_unHmdMatrix44PropertyTag: PropertyTypeTag_t = 21;
  k_unHmdVector3PropertyTag: PropertyTypeTag_t = 22;
  k_unHmdVector4PropertyTag: PropertyTypeTag_t = 23;
  k_unHmdVector2PropertyTag: PropertyTypeTag_t = 24;
  k_unHmdQuadPropertyTag: PropertyTypeTag_t = 25;
  k_unHiddenAreaPropertyTag: PropertyTypeTag_t = 30;
  k_unPathHandleInfoTag: PropertyTypeTag_t = 31;
  k_unActionPropertyTag: PropertyTypeTag_t = 32;
  k_unInputValuePropertyTag: PropertyTypeTag_t = 33;
  k_unWildcardPropertyTag: PropertyTypeTag_t = 34;
  k_unHapticVibrationPropertyTag: PropertyTypeTag_t = 35;
  k_unSkeletonPropertyTag: PropertyTypeTag_t = 36;
  k_unSpatialAnchorPosePropertyTag: PropertyTypeTag_t = 40;
  k_unJsonPropertyTag: PropertyTypeTag_t = 41;
  k_unActiveActionSetPropertyTag: PropertyTypeTag_t = 42;
  k_unOpenVRInternalReserved_Start: PropertyTypeTag_t = 1000;
  k_unOpenVRInternalReserved_End: PropertyTypeTag_t = 10000;
  k_unMaxPropertyStringSize: cuint32 = 32768;
  k_ulInvalidActionHandle: VRActionHandle_t = 0;
  k_ulInvalidActionSetHandle: VRActionSetHandle_t = 0;
  k_ulInvalidInputValueHandle: VRInputValueHandle_t = 0;
  k_unControllerStateAxisCount: cuint32 = 5;
  k_ulOverlayHandleInvalid: VROverlayHandle_t = 0;
  k_unMaxDistortionFunctionParameters: cuint32 = 8;
  k_unScreenshotHandleInvalid: cuint32 = 0;
  IVRSystem_Version: PChar = 'IVRSystem_022';
  IVRExtendedDisplay_Version: PChar = 'IVRExtendedDisplay_001';
  IVRTrackedCamera_Version: PChar = 'IVRTrackedCamera_006';
  k_unMaxApplicationKeyLength: cuint32 = 128;
  k_pch_MimeType_HomeApp: PChar = 'vr/home';
  k_pch_MimeType_GameTheater: PChar = 'vr/game_theater';
  IVRApplications_Version: PChar = 'IVRApplications_007';
  IVRChaperone_Version: PChar = 'IVRChaperone_004';
  IVRChaperoneSetup_Version: PChar = 'IVRChaperoneSetup_006';
  IVRCompositor_Version: PChar = 'IVRCompositor_026';
  k_unVROverlayMaxKeyLength: cuint32 = 128;
  k_unVROverlayMaxNameLength: cuint32 = 128;
  k_unMaxOverlayCount: cuint32 = 128;
  k_unMaxOverlayIntersectionMaskPrimitivesCount: cuint32 = 32;
  IVROverlay_Version: PChar = 'IVROverlay_024';
  IVROverlayView_Version: PChar = 'IVROverlayView_003';
  k_unHeadsetViewMaxWidth: cuint32 = 3840;
  k_unHeadsetViewMaxHeight: cuint32 = 2160;
  k_pchHeadsetViewOverlayKey: PChar = 'system.HeadsetView';
  IVRHeadsetView_Version: PChar = 'IVRHeadsetView_001';
  k_pch_Controller_Component_GDC2015: PChar = 'gdc2015';
  k_pch_Controller_Component_Base: PChar = 'base';
  k_pch_Controller_Component_Tip: PChar = 'tip';
  k_pch_Controller_Component_HandGrip: PChar = 'handgrip';
  k_pch_Controller_Component_Status: PChar = 'status';
  IVRRenderModels_Version: PChar = 'IVRRenderModels_006';
  k_unNotificationTextMaxSize: cuint32 = 256;
  IVRNotifications_Version: PChar = 'IVRNotifications_002';
  k_unMaxSettingsKeyLength: cuint32 = 128;
  IVRSettings_Version: PChar = 'IVRSettings_003';
  k_pch_SteamVR_Section: PChar = 'steamvr';
  k_pch_SteamVR_RequireHmd_String: PChar = 'requireHmd';
  k_pch_SteamVR_ForcedDriverKey_String: PChar = 'forcedDriver';
  k_pch_SteamVR_ForcedHmdKey_String: PChar = 'forcedHmd';
  k_pch_SteamVR_DisplayDebug_Bool: PChar = 'displayDebug';
  k_pch_SteamVR_DebugProcessPipe_String: PChar = 'debugProcessPipe';
  k_pch_SteamVR_DisplayDebugX_Int32: PChar = 'displayDebugX';
  k_pch_SteamVR_DisplayDebugY_Int32: PChar = 'displayDebugY';
  k_pch_SteamVR_SendSystemButtonToAllApps_Bool: PChar = 'sendSystemButtonToAllApps';
  k_pch_SteamVR_LogLevel_Int32: PChar = 'loglevel';
  k_pch_SteamVR_IPD_Float: PChar = 'ipd';
  k_pch_SteamVR_Background_String: PChar = 'background';
  k_pch_SteamVR_BackgroundUseDomeProjection_Bool: PChar = 'backgroundUseDomeProjection';
  k_pch_SteamVR_BackgroundCameraHeight_Float: PChar = 'backgroundCameraHeight';
  k_pch_SteamVR_BackgroundDomeRadius_Float: PChar = 'backgroundDomeRadius';
  k_pch_SteamVR_GridColor_String: PChar = 'gridColor';
  k_pch_SteamVR_PlayAreaColor_String: PChar = 'playAreaColor';
  k_pch_SteamVR_TrackingLossColor_String: PChar = 'trackingLossColor';
  k_pch_SteamVR_ShowStage_Bool: PChar = 'showStage';
  k_pch_SteamVR_ActivateMultipleDrivers_Bool: PChar = 'activateMultipleDrivers';
  k_pch_SteamVR_UsingSpeakers_Bool: PChar = 'usingSpeakers';
  k_pch_SteamVR_SpeakersForwardYawOffsetDegrees_Float: PChar = 'speakersForwardYawOffsetDegrees';
  k_pch_SteamVR_BaseStationPowerManagement_Int32: PChar = 'basestationPowerManagement';
  k_pch_SteamVR_ShowBaseStationPowerManagementTip_Int32: PChar = 'ShowBaseStationPowerManagementTip';
  k_pch_SteamVR_NeverKillProcesses_Bool: PChar = 'neverKillProcesses';
  k_pch_SteamVR_SupersampleScale_Float: PChar = 'supersampleScale';
  k_pch_SteamVR_MaxRecommendedResolution_Int32: PChar = 'maxRecommendedResolution';
  k_pch_SteamVR_MotionSmoothing_Bool: PChar = 'motionSmoothing';
  k_pch_SteamVR_MotionSmoothingOverride_Int32: PChar = 'motionSmoothingOverride';
  k_pch_SteamVR_DisableAsyncReprojection_Bool: PChar = 'disableAsync';
  k_pch_SteamVR_ForceFadeOnBadTracking_Bool: PChar = 'forceFadeOnBadTracking';
  k_pch_SteamVR_DefaultMirrorView_Int32: PChar = 'mirrorView';
  k_pch_SteamVR_ShowLegacyMirrorView_Bool: PChar = 'showLegacyMirrorView';
  k_pch_SteamVR_MirrorViewVisibility_Bool: PChar = 'showMirrorView';
  k_pch_SteamVR_MirrorViewDisplayMode_Int32: PChar = 'mirrorViewDisplayMode';
  k_pch_SteamVR_MirrorViewEye_Int32: PChar = 'mirrorViewEye';
  k_pch_SteamVR_MirrorViewGeometry_String: PChar = 'mirrorViewGeometry';
  k_pch_SteamVR_MirrorViewGeometryMaximized_String: PChar = 'mirrorViewGeometryMaximized';
  k_pch_SteamVR_PerfGraphVisibility_Bool: PChar = 'showPerfGraph';
  k_pch_SteamVR_StartMonitorFromAppLaunch: PChar = 'startMonitorFromAppLaunch';
  k_pch_SteamVR_StartCompositorFromAppLaunch_Bool: PChar = 'startCompositorFromAppLaunch';
  k_pch_SteamVR_StartDashboardFromAppLaunch_Bool: PChar = 'startDashboardFromAppLaunch';
  k_pch_SteamVR_StartOverlayAppsFromDashboard_Bool: PChar = 'startOverlayAppsFromDashboard';
  k_pch_SteamVR_EnableHomeApp: PChar = 'enableHomeApp';
  k_pch_SteamVR_CycleBackgroundImageTimeSec_Int32: PChar = 'CycleBackgroundImageTimeSec';
  k_pch_SteamVR_RetailDemo_Bool: PChar = 'retailDemo';
  k_pch_SteamVR_IpdOffset_Float: PChar = 'ipdOffset';
  k_pch_SteamVR_AllowSupersampleFiltering_Bool: PChar = 'allowSupersampleFiltering';
  k_pch_SteamVR_SupersampleManualOverride_Bool: PChar = 'supersampleManualOverride';
  k_pch_SteamVR_EnableLinuxVulkanAsync_Bool: PChar = 'enableLinuxVulkanAsync';
  k_pch_SteamVR_AllowDisplayLockedMode_Bool: PChar = 'allowDisplayLockedMode';
  k_pch_SteamVR_HaveStartedTutorialForNativeChaperoneDriver_Bool: PChar = 'haveStartedTutorialForNativeChaperoneDriver';
  k_pch_SteamVR_ForceWindows32bitVRMonitor: PChar = 'forceWindows32BitVRMonitor';
  k_pch_SteamVR_DebugInputBinding: PChar = 'debugInputBinding';
  k_pch_SteamVR_DoNotFadeToGrid: PChar = 'doNotFadeToGrid';
  k_pch_SteamVR_RenderCameraMode: PChar = 'renderCameraMode';
  k_pch_SteamVR_EnableSharedResourceJournaling: PChar = 'enableSharedResourceJournaling';
  k_pch_SteamVR_EnableSafeMode: PChar = 'enableSafeMode';
  k_pch_SteamVR_PreferredRefreshRate: PChar = 'preferredRefreshRate';
  k_pch_SteamVR_LastVersionNotice: PChar = 'lastVersionNotice';
  k_pch_SteamVR_LastVersionNoticeDate: PChar = 'lastVersionNoticeDate';
  k_pch_SteamVR_HmdDisplayColorGainR_Float: PChar = 'hmdDisplayColorGainR';
  k_pch_SteamVR_HmdDisplayColorGainG_Float: PChar = 'hmdDisplayColorGainG';
  k_pch_SteamVR_HmdDisplayColorGainB_Float: PChar = 'hmdDisplayColorGainB';
  k_pch_SteamVR_CustomIconStyle_String: PChar = 'customIconStyle';
  k_pch_SteamVR_CustomOffIconStyle_String: PChar = 'customOffIconStyle';
  k_pch_SteamVR_CustomIconForceUpdate_String: PChar = 'customIconForceUpdate';
  k_pch_SteamVR_AllowGlobalActionSetPriority: PChar = 'globalActionSetPriority';
  k_pch_SteamVR_OverlayRenderQuality: PChar = 'overlayRenderQuality_2';
  k_pch_SteamVR_BlockOculusSDKOnOpenVRLaunchOption_Bool: PChar = 'blockOculusSDKOnOpenVRLaunchOption';
  k_pch_SteamVR_BlockOculusSDKOnAllLaunches_Bool: PChar = 'blockOculusSDKOnAllLaunches';
  k_pch_DirectMode_Section: PChar = 'direct_mode';
  k_pch_DirectMode_Enable_Bool: PChar = 'enable';
  k_pch_DirectMode_Count_Int32: PChar = 'count';
  k_pch_DirectMode_EdidVid_Int32: PChar = 'edidVid';
  k_pch_DirectMode_EdidPid_Int32: PChar = 'edidPid';
  k_pch_Lighthouse_Section: PChar = 'driver_lighthouse';
  k_pch_Lighthouse_DisableIMU_Bool: PChar = 'disableimu';
  k_pch_Lighthouse_DisableIMUExceptHMD_Bool: PChar = 'disableimuexcepthmd';
  k_pch_Lighthouse_UseDisambiguation_String: PChar = 'usedisambiguation';
  k_pch_Lighthouse_DisambiguationDebug_Int32: PChar = 'disambiguationdebug';
  k_pch_Lighthouse_PrimaryBasestation_Int32: PChar = 'primarybasestation';
  k_pch_Lighthouse_DBHistory_Bool: PChar = 'dbhistory';
  k_pch_Lighthouse_EnableBluetooth_Bool: PChar = 'enableBluetooth';
  k_pch_Lighthouse_PowerManagedBaseStations_String: PChar = 'PowerManagedBaseStations';
  k_pch_Lighthouse_PowerManagedBaseStations2_String: PChar = 'PowerManagedBaseStations2';
  k_pch_Lighthouse_InactivityTimeoutForBaseStations_Int32: PChar = 'InactivityTimeoutForBaseStations';
  k_pch_Lighthouse_EnableImuFallback_Bool: PChar = 'enableImuFallback';
  k_pch_Null_Section: PChar = 'driver_null';
  k_pch_Null_SerialNumber_String: PChar = 'serialNumber';
  k_pch_Null_ModelNumber_String: PChar = 'modelNumber';
  k_pch_Null_WindowX_Int32: PChar = 'windowX';
  k_pch_Null_WindowY_Int32: PChar = 'windowY';
  k_pch_Null_WindowWidth_Int32: PChar = 'windowWidth';
  k_pch_Null_WindowHeight_Int32: PChar = 'windowHeight';
  k_pch_Null_RenderWidth_Int32: PChar = 'renderWidth';
  k_pch_Null_RenderHeight_Int32: PChar = 'renderHeight';
  k_pch_Null_SecondsFromVsyncToPhotons_Float: PChar = 'secondsFromVsyncToPhotons';
  k_pch_Null_DisplayFrequency_Float: PChar = 'displayFrequency';
  k_pch_WindowsMR_Section: PChar = 'driver_holographic';
  k_pch_UserInterface_Section: PChar = 'userinterface';
  k_pch_UserInterface_StatusAlwaysOnTop_Bool: PChar = 'StatusAlwaysOnTop';
  k_pch_UserInterface_MinimizeToTray_Bool: PChar = 'MinimizeToTray';
  k_pch_UserInterface_HidePopupsWhenStatusMinimized_Bool: PChar = 'HidePopupsWhenStatusMinimized';
  k_pch_UserInterface_Screenshots_Bool: PChar = 'screenshots';
  k_pch_UserInterface_ScreenshotType_Int: PChar = 'screenshotType';
  k_pch_Notifications_Section: PChar = 'notifications';
  k_pch_Notifications_DoNotDisturb_Bool: PChar = 'DoNotDisturb';
  k_pch_Keyboard_Section: PChar = 'keyboard';
  k_pch_Keyboard_TutorialCompletions: PChar = 'TutorialCompletions';
  k_pch_Keyboard_ScaleX: PChar = 'ScaleX';
  k_pch_Keyboard_ScaleY: PChar = 'ScaleY';
  k_pch_Keyboard_OffsetLeftX: PChar = 'OffsetLeftX';
  k_pch_Keyboard_OffsetRightX: PChar = 'OffsetRightX';
  k_pch_Keyboard_OffsetY: PChar = 'OffsetY';
  k_pch_Keyboard_Smoothing: PChar = 'Smoothing';
  k_pch_Perf_Section: PChar = 'perfcheck';
  k_pch_Perf_PerfGraphInHMD_Bool: PChar = 'perfGraphInHMD';
  k_pch_Perf_AllowTimingStore_Bool: PChar = 'allowTimingStore';
  k_pch_Perf_SaveTimingsOnExit_Bool: PChar = 'saveTimingsOnExit';
  k_pch_Perf_TestData_Float: PChar = 'perfTestData';
  k_pch_Perf_GPUProfiling_Bool: PChar = 'GPUProfiling';
  k_pch_CollisionBounds_Section: PChar = 'collisionBounds';
  k_pch_CollisionBounds_Style_Int32: PChar = 'CollisionBoundsStyle';
  k_pch_CollisionBounds_GroundPerimeterOn_Bool: PChar = 'CollisionBoundsGroundPerimeterOn';
  k_pch_CollisionBounds_CenterMarkerOn_Bool: PChar = 'CollisionBoundsCenterMarkerOn';
  k_pch_CollisionBounds_PlaySpaceOn_Bool: PChar = 'CollisionBoundsPlaySpaceOn';
  k_pch_CollisionBounds_FadeDistance_Float: PChar = 'CollisionBoundsFadeDistance';
  k_pch_CollisionBounds_WallHeight_Float: PChar = 'CollisionBoundsWallHeight';
  k_pch_CollisionBounds_ColorGammaR_Int32: PChar = 'CollisionBoundsColorGammaR';
  k_pch_CollisionBounds_ColorGammaG_Int32: PChar = 'CollisionBoundsColorGammaG';
  k_pch_CollisionBounds_ColorGammaB_Int32: PChar = 'CollisionBoundsColorGammaB';
  k_pch_CollisionBounds_ColorGammaA_Int32: PChar = 'CollisionBoundsColorGammaA';
  k_pch_CollisionBounds_EnableDriverImport: PChar = 'enableDriverBoundsImport';
  k_pch_Camera_Section: PChar = 'camera';
  k_pch_Camera_EnableCamera_Bool: PChar = 'enableCamera';
  k_pch_Camera_ShowOnController_Bool: PChar = 'showOnController';
  k_pch_Camera_EnableCameraForCollisionBounds_Bool: PChar = 'enableCameraForCollisionBounds';
  k_pch_Camera_RoomView_Int32: PChar = 'roomView';
  k_pch_Camera_BoundsColorGammaR_Int32: PChar = 'cameraBoundsColorGammaR';
  k_pch_Camera_BoundsColorGammaG_Int32: PChar = 'cameraBoundsColorGammaG';
  k_pch_Camera_BoundsColorGammaB_Int32: PChar = 'cameraBoundsColorGammaB';
  k_pch_Camera_BoundsColorGammaA_Int32: PChar = 'cameraBoundsColorGammaA';
  k_pch_Camera_BoundsStrength_Int32: PChar = 'cameraBoundsStrength';
  k_pch_Camera_RoomViewStyle_Int32: PChar = 'roomViewStyle';
  k_pch_audio_Section: PChar = 'audio';
  k_pch_audio_SetOsDefaultPlaybackDevice_Bool: PChar = 'setOsDefaultPlaybackDevice';
  k_pch_audio_EnablePlaybackDeviceOverride_Bool: PChar = 'enablePlaybackDeviceOverride';
  k_pch_audio_PlaybackDeviceOverride_String: PChar = 'playbackDeviceOverride';
  k_pch_audio_PlaybackDeviceOverrideName_String: PChar = 'playbackDeviceOverrideName';
  k_pch_audio_SetOsDefaultRecordingDevice_Bool: PChar = 'setOsDefaultRecordingDevice';
  k_pch_audio_EnableRecordingDeviceOverride_Bool: PChar = 'enableRecordingDeviceOverride';
  k_pch_audio_RecordingDeviceOverride_String: PChar = 'recordingDeviceOverride';
  k_pch_audio_RecordingDeviceOverrideName_String: PChar = 'recordingDeviceOverrideName';
  k_pch_audio_EnablePlaybackMirror_Bool: PChar = 'enablePlaybackMirror';
  k_pch_audio_PlaybackMirrorDevice_String: PChar = 'playbackMirrorDevice';
  k_pch_audio_PlaybackMirrorDeviceName_String: PChar = 'playbackMirrorDeviceName';
  k_pch_audio_OldPlaybackMirrorDevice_String: PChar = 'onPlaybackMirrorDevice';
  k_pch_audio_ActiveMirrorDevice_String: PChar = 'activePlaybackMirrorDevice';
  k_pch_audio_EnablePlaybackMirrorIndependentVolume_Bool: PChar = 'enablePlaybackMirrorIndependentVolume';
  k_pch_audio_LastHmdPlaybackDeviceId_String: PChar = 'lastHmdPlaybackDeviceId';
  k_pch_audio_VIVEHDMIGain: PChar = 'viveHDMIGain';
  k_pch_audio_DualSpeakerAndJackOutput_Bool: PChar = 'dualSpeakerAndJackOutput';
  k_pch_Power_Section: PChar = 'power';
  k_pch_Power_PowerOffOnExit_Bool: PChar = 'powerOffOnExit';
  k_pch_Power_TurnOffScreensTimeout_Float: PChar = 'turnOffScreensTimeout';
  k_pch_Power_TurnOffControllersTimeout_Float: PChar = 'turnOffControllersTimeout';
  k_pch_Power_ReturnToWatchdogTimeout_Float: PChar = 'returnToWatchdogTimeout';
  k_pch_Power_AutoLaunchSteamVROnButtonPress: PChar = 'autoLaunchSteamVROnButtonPress';
  k_pch_Power_PauseCompositorOnStandby_Bool: PChar = 'pauseCompositorOnStandby';
  k_pch_Dashboard_Section: PChar = 'dashboard';
  k_pch_Dashboard_EnableDashboard_Bool: PChar = 'enableDashboard';
  k_pch_Dashboard_ArcadeMode_Bool: PChar = 'arcadeMode';
  k_pch_Dashboard_Position: PChar = 'position';
  k_pch_Dashboard_DesktopScale: PChar = 'desktopScale';
  k_pch_Dashboard_DashboardScale: PChar = 'dashboardScale';
  k_pch_modelskin_Section: PChar = 'modelskins';
  k_pch_Driver_Enable_Bool: PChar = 'enable';
  k_pch_Driver_BlockedBySafemode_Bool: PChar = 'blocked_by_safe_mode';
  k_pch_Driver_LoadPriority_Int32: PChar = 'loadPriority';
  k_pch_WebInterface_Section: PChar = 'WebInterface';
  k_pch_VRWebHelper_Section: PChar = 'VRWebHelper';
  k_pch_VRWebHelper_DebuggerEnabled_Bool: PChar = 'DebuggerEnabled';
  k_pch_VRWebHelper_DebuggerPort_Int32: PChar = 'DebuggerPort';
  k_pch_TrackingOverride_Section: PChar = 'TrackingOverrides';
  k_pch_App_BindingAutosaveURLSuffix_String: PChar = 'AutosaveURL';
  k_pch_App_BindingLegacyAPISuffix_String: PChar = '_legacy';
  k_pch_App_BindingSteamVRInputAPISuffix_String: PChar = '_steamvrinput';
  k_pch_App_BindingCurrentURLSuffix_String: PChar = 'CurrentURL';
  k_pch_App_BindingPreviousURLSuffix_String: PChar = 'PreviousURL';
  k_pch_App_NeedToUpdateAutosaveSuffix_Bool: PChar = 'NeedToUpdateAutosave';
  k_pch_App_DominantHand_Int32: PChar = 'DominantHand';
  k_pch_App_BlockOculusSDK_Bool: PChar = 'blockOculusSDK';
  k_pch_Trackers_Section: PChar = 'trackers';
  k_pch_DesktopUI_Section: PChar = 'DesktopUI';
  k_pch_LastKnown_Section: PChar = 'LastKnown';
  k_pch_LastKnown_HMDManufacturer_String: PChar = 'HMDManufacturer';
  k_pch_LastKnown_HMDModel_String: PChar = 'HMDModel';
  k_pch_DismissedWarnings_Section: PChar = 'DismissedWarnings';
  k_pch_Input_Section: PChar = 'input';
  k_pch_Input_LeftThumbstickRotation_Float: PChar = 'leftThumbstickRotation';
  k_pch_Input_RightThumbstickRotation_Float: PChar = 'rightThumbstickRotation';
  k_pch_Input_ThumbstickDeadzone_Float: PChar = 'thumbstickDeadzone';
  k_pch_GpuSpeed_Section: PChar = 'GpuSpeed';
  IVRScreenshots_Version: PChar = 'IVRScreenshots_001';
  IVRResources_Version: PChar = 'IVRResources_001';
  IVRDriverManager_Version: PChar = 'IVRDriverManager_001';
  k_unMaxActionNameLength: cuint32 = 64;
  k_unMaxActionSetNameLength: cuint32 = 64;
  k_unMaxActionOriginCount: cuint32 = 16;
  k_unMaxBoneNameLength: cuint32 = 32;
  k_nActionSetOverlayGlobalPriorityMin: cint32 = 16777216;
  k_nActionSetOverlayGlobalPriorityMax: cint32 = 33554431;
  k_nActionSetPriorityReservedMin: cint32 = 33554432;
  IVRInput_Version: PChar = 'IVRInput_010';
  k_ulInvalidIOBufferHandle: cuint64 = 0;
  IVRIOBuffer_Version: PChar = 'IVRIOBuffer_002';
  k_ulInvalidSpatialAnchorHandle: SpatialAnchorHandle_t = 0;
  IVRSpatialAnchors_Version: PChar = 'IVRSpatialAnchors_001';
  IVRDebug_Version: PChar = 'IVRDebug_001';
  k_ulDisplayRedirectContainer: PropertyContainerHandle_t = 25769803779;
  IVRProperties_Version: PChar = 'IVRProperties_001';
  k_pchPathUserHandRight: PChar = '/user/hand/right';
  k_pchPathUserHandLeft: PChar = '/user/hand/left';
  k_pchPathUserHandPrimary: PChar = '/user/hand/primary';
  k_pchPathUserHandSecondary: PChar = '/user/hand/secondary';
  k_pchPathUserHead: PChar = '/user/head';
  k_pchPathUserGamepad: PChar = '/user/gamepad';
  k_pchPathUserTreadmill: PChar = '/user/treadmill';
  k_pchPathUserStylus: PChar = '/user/stylus';
  k_pchPathDevices: PChar = '/devices';
  k_pchPathDevicePath: PChar = '/device_path';
  k_pchPathBestAliasPath: PChar = '/best_alias_path';
  k_pchPathBoundTrackerAliasPath: PChar = '/bound_tracker_path';
  k_pchPathBoundTrackerRole: PChar = '/bound_tracker_role';
  k_pchPathPoseRaw: PChar = '/pose/raw';
  k_pchPathPoseTip: PChar = '/pose/tip';
  k_pchPathPoseGrip: PChar = '/pose/grip';
  k_pchPathSystemButtonClick: PChar = '/input/system/click';
  k_pchPathProximity: PChar = '/proximity';
  k_pchPathControllerTypePrefix: PChar = '/controller_type/';
  k_pchPathInputProfileSuffix: PChar = '/input_profile';
  k_pchPathBindingNameSuffix: PChar = '/binding_name';
  k_pchPathBindingUrlSuffix: PChar = '/binding_url';
  k_pchPathBindingErrorSuffix: PChar = '/binding_error';
  k_pchPathActiveActionSets: PChar = '/active_action_sets';
  k_pchPathComponentUpdates: PChar = '/total_component_updates';
  k_pchPathUserFootLeft: PChar = '/user/foot/left';
  k_pchPathUserFootRight: PChar = '/user/foot/right';
  k_pchPathUserShoulderLeft: PChar = '/user/shoulder/left';
  k_pchPathUserShoulderRight: PChar = '/user/shoulder/right';
  k_pchPathUserElbowLeft: PChar = '/user/elbow/left';
  k_pchPathUserElbowRight: PChar = '/user/elbow/right';
  k_pchPathUserKneeLeft: PChar = '/user/knee/left';
  k_pchPathUserKneeRight: PChar = '/user/knee/right';
  k_pchPathUserWaist: PChar = '/user/waist';
  k_pchPathUserChest: PChar = '/user/chest';
  k_pchPathUserCamera: PChar = '/user/camera';
  k_pchPathUserKeyboard: PChar = '/user/keyboard';
  k_pchPathClientAppKey: PChar = '/client_info/app_key';
  k_ulInvalidPathHandle: PathHandle_t = 0;
  IVRPaths_Version: PChar = 'IVRPaths_001';
  IVRBlockQueue_Version: PChar = 'IVRBlockQueue_004';

type
  FnTable_VR_InitInternal = procedure(peError: Pointer; eType: EVRApplicationType); OVRCALL;
  FnTable_VR_ShutdownInternal = procedure; OVRCALL;
  FnTable_VR_IsHmdPresent = function: Boolean; OVRCALL;
  FnTable_VR_GetGenericInterface = function(pchInterfaceVersion: PChar; peError: Pointer): Pointer; OVRCALL;
  FnTable_VR_IsRuntimeInstalled = function: Boolean; OVRCALL;
  FnTable_VR_GetVRInitErrorAsSymbol = function(error: EVRInitError): PChar; OVRCALL;
  FnTable_VR_GetVRInitErrorAsEnglishDescription = function(error: EVRInitError): PChar; OVRCALL;

  FnTable_IVRSystem_GetRecommendedRenderTargetSize = procedure(pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}); OVRCALL;
  FnTable_IVRSystem_GetProjectionMatrix = function(eEye: EVREye; fNearZ: cfloat; fFarZ: cfloat): HmdMatrix44_t; OVRCALL;
  FnTable_IVRSystem_GetProjectionRaw = procedure(eEye: EVREye; pfLeft: Pointer {float}; pfRight: Pointer {float}; pfTop: Pointer {float}; pfBottom: Pointer {float}); OVRCALL;
  FnTable_IVRSystem_ComputeDistortion = function(eEye: EVREye; fU: cfloat; fV: cfloat; pDistortionCoordinates: Pointer {DistortionCoordinates_t}): cbool; OVRCALL;
  FnTable_IVRSystem_GetEyeToHeadTransform = function(eEye: EVREye): HmdMatrix34_t; OVRCALL;
  FnTable_IVRSystem_GetTimeSinceLastVsync = function(pfSecondsSinceLastVsync: Pointer {float}; pulFrameCounter: Pointer {uint64_t}): cbool; OVRCALL;
  FnTable_IVRSystem_GetD3D9AdapterIndex = function: cint32; OVRCALL;
  FnTable_IVRSystem_GetDXGIOutputInfo = procedure(pnAdapterIndex: Pointer {int32_t}); OVRCALL;
  FnTable_IVRSystem_GetOutputDevice = procedure(pnDevice: Pointer {uint64_t}; textureType: ETextureType; pInstance: Pointer {VkInstance_T}); OVRCALL;
  FnTable_IVRSystem_IsDisplayOnDesktop = function: cbool; OVRCALL;
  FnTable_IVRSystem_SetDisplayVisibility = function(bIsVisibleOnDesktop: cbool): cbool; OVRCALL;
  FnTable_IVRSystem_GetDeviceToAbsoluteTrackingPose = procedure(eOrigin: ETrackingUniverseOrigin; fPredictedSecondsToPhotonsFromNow: cfloat; pTrackedDevicePoseArray: Pointer {TrackedDevicePose_t}; unTrackedDevicePoseArrayCount: cuint32); OVRCALL;
  FnTable_IVRSystem_GetSeatedZeroPoseToStandingAbsoluteTrackingPose = function: HmdMatrix34_t; OVRCALL;
  FnTable_IVRSystem_GetRawZeroPoseToStandingAbsoluteTrackingPose = function: HmdMatrix34_t; OVRCALL;
  FnTable_IVRSystem_GetSortedTrackedDeviceIndicesOfClass = function(eTrackedDeviceClass: ETrackedDeviceClass; punTrackedDeviceIndexArray: Pointer {TrackedDeviceIndex_t}; unTrackedDeviceIndexArrayCount: cuint32; unRelativeToTrackedDeviceIndex: TrackedDeviceIndex_t): cuint32; OVRCALL;
  FnTable_IVRSystem_GetTrackedDeviceActivityLevel = function(unDeviceId: TrackedDeviceIndex_t): EDeviceActivityLevel; OVRCALL;
  FnTable_IVRSystem_ApplyTransform = procedure(pOutputPose: Pointer {TrackedDevicePose_t}; pTrackedDevicePose: Pointer {TrackedDevicePose_t}; pTransform: Pointer {HmdMatrix34_t}); OVRCALL;
  FnTable_IVRSystem_GetTrackedDeviceIndexForControllerRole = function(unDeviceType: ETrackedControllerRole): TrackedDeviceIndex_t; OVRCALL;
  FnTable_IVRSystem_GetControllerRoleForTrackedDeviceIndex = function(unDeviceIndex: TrackedDeviceIndex_t): ETrackedControllerRole; OVRCALL;
  FnTable_IVRSystem_GetTrackedDeviceClass = function(unDeviceIndex: TrackedDeviceIndex_t): ETrackedDeviceClass; OVRCALL;
  FnTable_IVRSystem_IsTrackedDeviceConnected = function(unDeviceIndex: TrackedDeviceIndex_t): cbool; OVRCALL;
  FnTable_IVRSystem_GetBoolTrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pError: Pointer {ETrackedPropertyError}): cbool; OVRCALL;
  FnTable_IVRSystem_GetFloatTrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pError: Pointer {ETrackedPropertyError}): cfloat; OVRCALL;
  FnTable_IVRSystem_GetInt32TrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pError: Pointer {ETrackedPropertyError}): cint32; OVRCALL;
  FnTable_IVRSystem_GetUint64TrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pError: Pointer {ETrackedPropertyError}): cuint64; OVRCALL;
  FnTable_IVRSystem_GetMatrix34TrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pError: Pointer {ETrackedPropertyError}): HmdMatrix34_t; OVRCALL;
  FnTable_IVRSystem_GetArrayTrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; propType: PropertyTypeTag_t; pBuffer: Pointer; unBufferSize: cuint32; pError: Pointer {ETrackedPropertyError}): cuint32; OVRCALL;
  FnTable_IVRSystem_GetStringTrackedDeviceProperty = function(unDeviceIndex: TrackedDeviceIndex_t; prop: ETrackedDeviceProperty; pchValue: PChar; unBufferSize: cuint32; pError: Pointer {ETrackedPropertyError}): cuint32; OVRCALL;
  FnTable_IVRSystem_GetPropErrorNameFromEnum = function(error: ETrackedPropertyError): PChar; OVRCALL;
  FnTable_IVRSystem_PollNextEvent = function(pEvent: Pointer {VREvent_t}; uncbVREvent: cuint32): cbool; OVRCALL;
  FnTable_IVRSystem_PollNextEventWithPose = function(eOrigin: ETrackingUniverseOrigin; pEvent: Pointer {VREvent_t}; uncbVREvent: cuint32; pTrackedDevicePose: Pointer {TrackedDevicePose_t}): cbool; OVRCALL;
  FnTable_IVRSystem_GetEventTypeNameFromEnum = function(eType: EVREventType): PChar; OVRCALL;
  FnTable_IVRSystem_GetHiddenAreaMesh = function(eEye: EVREye; type_: EHiddenAreaMeshType): HiddenAreaMesh_t; OVRCALL;
  FnTable_IVRSystem_GetControllerState = function(unControllerDeviceIndex: TrackedDeviceIndex_t; pControllerState: Pointer {VRControllerState_t}; unControllerStateSize: cuint32): cbool; OVRCALL;
  FnTable_IVRSystem_GetControllerStateWithPose = function(eOrigin: ETrackingUniverseOrigin; unControllerDeviceIndex: TrackedDeviceIndex_t; pControllerState: Pointer {VRControllerState_t}; unControllerStateSize: cuint32; pTrackedDevicePose: Pointer {TrackedDevicePose_t}): cbool; OVRCALL;
  FnTable_IVRSystem_TriggerHapticPulse = procedure(unControllerDeviceIndex: TrackedDeviceIndex_t; unAxisId: cuint32; usDurationMicroSec: Byte); OVRCALL;
  FnTable_IVRSystem_GetButtonIdNameFromEnum = function(eButtonId: EVRButtonId): PChar; OVRCALL;
  FnTable_IVRSystem_GetControllerAxisTypeNameFromEnum = function(eAxisType: EVRControllerAxisType): PChar; OVRCALL;
  FnTable_IVRSystem_IsInputAvailable = function: cbool; OVRCALL;
  FnTable_IVRSystem_IsSteamVRDrawingControllers = function: cbool; OVRCALL;
  FnTable_IVRSystem_ShouldApplicationPause = function: cbool; OVRCALL;
  FnTable_IVRSystem_ShouldApplicationReduceRenderingWork = function: cbool; OVRCALL;
  FnTable_IVRSystem_PerformFirmwareUpdate = function(unDeviceIndex: TrackedDeviceIndex_t): EVRFirmwareError; OVRCALL;
  FnTable_IVRSystem_AcknowledgeQuit_Exiting = procedure; OVRCALL;
  FnTable_IVRSystem_GetAppContainerFilePaths = function(pchBuffer: PChar; unBufferSize: cuint32): cuint32; OVRCALL;
  FnTable_IVRSystem_GetRuntimeVersion = function: PChar; OVRCALL;

  FnTable_IVRExtendedDisplay_GetWindowBounds = procedure(pnX: Pointer {int32_t}; pnY: Pointer {int32_t}; pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}); OVRCALL;
  FnTable_IVRExtendedDisplay_GetEyeOutputViewport = procedure(eEye: EVREye; pnX: Pointer {uint32_t}; pnY: Pointer {uint32_t}; pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}); OVRCALL;
  FnTable_IVRExtendedDisplay_GetDXGIOutputInfo = procedure(pnAdapterIndex: Pointer {int32_t}; pnAdapterOutputIndex: Pointer {int32_t}); OVRCALL;

  FnTable_IVRTrackedCamera_GetCameraErrorNameFromEnum = function(eCameraError: EVRTrackedCameraError): PChar; OVRCALL;
  FnTable_IVRTrackedCamera_HasCamera = function(nDeviceIndex: TrackedDeviceIndex_t; pHasCamera: Pointer {bool}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetCameraFrameSize = function(nDeviceIndex: TrackedDeviceIndex_t; eFrameType: EVRTrackedCameraFrameType; pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}; pnFrameBufferSize: Pointer {uint32_t}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetCameraIntrinsics = function(nDeviceIndex: TrackedDeviceIndex_t; nCameraIndex: cuint32; eFrameType: EVRTrackedCameraFrameType; pFocalLength: Pointer {HmdVector2_t}; pCenter: Pointer {HmdVector2_t}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetCameraProjection = function(nDeviceIndex: TrackedDeviceIndex_t; nCameraIndex: cuint32; eFrameType: EVRTrackedCameraFrameType; flZNear: cfloat; flZFar: cfloat; pProjection: Pointer {HmdMatrix44_t}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_AcquireVideoStreamingService = function(nDeviceIndex: TrackedDeviceIndex_t; pHandle: Pointer {TrackedCameraHandle_t}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_ReleaseVideoStreamingService = function(hTrackedCamera: TrackedCameraHandle_t): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetVideoStreamFrameBuffer = function(hTrackedCamera: TrackedCameraHandle_t; eFrameType: EVRTrackedCameraFrameType; pFrameBuffer: Pointer; nFrameBufferSize: cuint32; pFrameHeader: Pointer {CameraVideoStreamFrameHeader_t}; nFrameHeaderSize: cuint32): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetVideoStreamTextureSize = function(nDeviceIndex: TrackedDeviceIndex_t; eFrameType: EVRTrackedCameraFrameType; pTextureBounds: Pointer {VRTextureBounds_t}; pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetVideoStreamTextureD3D11 = function(hTrackedCamera: TrackedCameraHandle_t; eFrameType: EVRTrackedCameraFrameType; pD3D11DeviceOrResource: Pointer; ppD3D11ShaderResourceView: Pointer {void*}; pFrameHeader: Pointer {CameraVideoStreamFrameHeader_t}; nFrameHeaderSize: cuint32): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_GetVideoStreamTextureGL = function(hTrackedCamera: TrackedCameraHandle_t; eFrameType: EVRTrackedCameraFrameType; pglTextureId: Pointer {glUInt_t}; pFrameHeader: Pointer {CameraVideoStreamFrameHeader_t}; nFrameHeaderSize: cuint32): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_ReleaseVideoStreamTextureGL = function(hTrackedCamera: TrackedCameraHandle_t; glTextureId: glUInt_t): EVRTrackedCameraError; OVRCALL;
  FnTable_IVRTrackedCamera_SetCameraTrackingSpace = procedure(eUniverse: ETrackingUniverseOrigin); OVRCALL;
  FnTable_IVRTrackedCamera_GetCameraTrackingSpace = function: ETrackingUniverseOrigin; OVRCALL;

  FnTable_IVRApplications_AddApplicationManifest = function(pchApplicationManifestFullPath: PChar; bTemporary: cbool): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_RemoveApplicationManifest = function(pchApplicationManifestFullPath: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_IsApplicationInstalled = function(pchAppKey: PChar): cbool; OVRCALL;
  FnTable_IVRApplications_GetApplicationCount = function: cuint32; OVRCALL;
  FnTable_IVRApplications_GetApplicationKeyByIndex = function(unApplicationIndex: cuint32; pchAppKeyBuffer: PChar; unAppKeyBufferLen: cuint32): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetApplicationKeyByProcessId = function(unProcessId: cuint32; pchAppKeyBuffer: PChar; unAppKeyBufferLen: cuint32): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_LaunchApplication = function(pchAppKey: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_LaunchTemplateApplication = function(pchTemplateAppKey: PChar; pchNewAppKey: PChar; pKeys: Pointer {AppOverrideKeys_t}; unKeys: cuint32): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_LaunchApplicationFromMimeType = function(pchMimeType: PChar; pchArgs: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_LaunchDashboardOverlay = function(pchAppKey: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_CancelApplicationLaunch = function(pchAppKey: PChar): cbool; OVRCALL;
  FnTable_IVRApplications_IdentifyApplication = function(unProcessId: cuint32; pchAppKey: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetApplicationProcessId = function(pchAppKey: PChar): cuint32; OVRCALL;
  FnTable_IVRApplications_GetApplicationsErrorNameFromEnum = function(error: EVRApplicationError): PChar; OVRCALL;
  FnTable_IVRApplications_GetApplicationPropertyString = function(pchAppKey: PChar; eProperty: EVRApplicationProperty; pchPropertyValueBuffer: PChar; unPropertyValueBufferLen: cuint32; peError: Pointer {EVRApplicationError}): cuint32; OVRCALL;
  FnTable_IVRApplications_GetApplicationPropertyBool = function(pchAppKey: PChar; eProperty: EVRApplicationProperty; peError: Pointer {EVRApplicationError}): cbool; OVRCALL;
  FnTable_IVRApplications_GetApplicationPropertyUint64 = function(pchAppKey: PChar; eProperty: EVRApplicationProperty; peError: Pointer {EVRApplicationError}): cuint64; OVRCALL;
  FnTable_IVRApplications_SetApplicationAutoLaunch = function(pchAppKey: PChar; bAutoLaunch: cbool): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetApplicationAutoLaunch = function(pchAppKey: PChar): cbool; OVRCALL;
  FnTable_IVRApplications_SetDefaultApplicationForMimeType = function(pchAppKey: PChar; pchMimeType: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetDefaultApplicationForMimeType = function(pchMimeType: PChar; pchAppKeyBuffer: PChar; unAppKeyBufferLen: cuint32): cbool; OVRCALL;
  FnTable_IVRApplications_GetApplicationSupportedMimeTypes = function(pchAppKey: PChar; pchMimeTypesBuffer: PChar; unMimeTypesBuffer: cuint32): cbool; OVRCALL;
  FnTable_IVRApplications_GetApplicationsThatSupportMimeType = function(pchMimeType: PChar; pchAppKeysThatSupportBuffer: PChar; unAppKeysThatSupportBuffer: cuint32): cuint32; OVRCALL;
  FnTable_IVRApplications_GetApplicationLaunchArguments = function(unHandle: cuint32; pchArgs: PChar; unArgs: cuint32): cuint32; OVRCALL;
  FnTable_IVRApplications_GetStartingApplication = function(pchAppKeyBuffer: PChar; unAppKeyBufferLen: cuint32): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetSceneApplicationState = function: EVRSceneApplicationState; OVRCALL;
  FnTable_IVRApplications_PerformApplicationPrelaunchCheck = function(pchAppKey: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetSceneApplicationStateNameFromEnum = function(state: EVRSceneApplicationState): PChar; OVRCALL;
  FnTable_IVRApplications_LaunchInternalProcess = function(pchBinaryPath: PChar; pchArguments: PChar; pchWorkingDirectory: PChar): EVRApplicationError; OVRCALL;
  FnTable_IVRApplications_GetCurrentSceneProcessId = function: cuint32; OVRCALL;

  FnTable_IVRChaperone_GetCalibrationState = function: ChaperoneCalibrationState; OVRCALL;
  FnTable_IVRChaperone_GetPlayAreaSize = function(pSizeX: Pointer {float}; pSizeZ: Pointer {float}): cbool; OVRCALL;
  FnTable_IVRChaperone_GetPlayAreaRect = function(rect: Pointer {HmdQuad_t}): cbool; OVRCALL;
  FnTable_IVRChaperone_ReloadInfo = procedure; OVRCALL;
  FnTable_IVRChaperone_SetSceneColor = procedure(color: HmdColor_t); OVRCALL;
  FnTable_IVRChaperone_GetBoundsColor = procedure(pOutputColorArray: Pointer {HmdColor_t}; nNumOutputColors: Integer; flCollisionBoundsFadeDistance: cfloat; pOutputCameraColor: Pointer {HmdColor_t}); OVRCALL;
  FnTable_IVRChaperone_AreBoundsVisible = function: cbool; OVRCALL;
  FnTable_IVRChaperone_ForceBoundsVisible = procedure(bForce: cbool); OVRCALL;
  FnTable_IVRChaperone_ResetZeroPose = procedure(eTrackingUniverseOrigin: ETrackingUniverseOrigin); OVRCALL;

  FnTable_IVRChaperoneSetup_CommitWorkingCopy = function(configFile: EChaperoneConfigFile): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_RevertWorkingCopy = procedure; OVRCALL;
  FnTable_IVRChaperoneSetup_GetWorkingPlayAreaSize = function(pSizeX: Pointer {float}; pSizeZ: Pointer {float}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_GetWorkingPlayAreaRect = function(rect: Pointer {HmdQuad_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_GetWorkingCollisionBoundsInfo = function(pQuadsBuffer: Pointer {HmdQuad_t}; punQuadsCount: Pointer {uint32_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_GetLiveCollisionBoundsInfo = function(pQuadsBuffer: Pointer {HmdQuad_t}; punQuadsCount: Pointer {uint32_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_GetWorkingSeatedZeroPoseToRawTrackingPose = function(pmatSeatedZeroPoseToRawTrackingPose: Pointer {HmdMatrix34_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_GetWorkingStandingZeroPoseToRawTrackingPose = function(pmatStandingZeroPoseToRawTrackingPose: Pointer {HmdMatrix34_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_SetWorkingPlayAreaSize = procedure(sizeX: cfloat; sizeZ: cfloat); OVRCALL;
  FnTable_IVRChaperoneSetup_SetWorkingCollisionBoundsInfo = procedure(pQuadsBuffer: Pointer {HmdQuad_t}; unQuadsCount: cuint32); OVRCALL;
  FnTable_IVRChaperoneSetup_SetWorkingPerimeter = procedure(pPointBuffer: Pointer {HmdVector2_t}; unPointCount: cuint32); OVRCALL;
  FnTable_IVRChaperoneSetup_SetWorkingSeatedZeroPoseToRawTrackingPose = procedure(pMatSeatedZeroPoseToRawTrackingPose: Pointer {HmdMatrix34_t}); OVRCALL;
  FnTable_IVRChaperoneSetup_SetWorkingStandingZeroPoseToRawTrackingPose = procedure(pMatStandingZeroPoseToRawTrackingPose: Pointer {HmdMatrix34_t}); OVRCALL;
  FnTable_IVRChaperoneSetup_ReloadFromDisk = procedure(configFile: EChaperoneConfigFile); OVRCALL;
  FnTable_IVRChaperoneSetup_GetLiveSeatedZeroPoseToRawTrackingPose = function(pmatSeatedZeroPoseToRawTrackingPose: Pointer {HmdMatrix34_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_ExportLiveToBuffer = function(pBuffer: PChar; pnBufferLength: Pointer {uint32_t}): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_ImportFromBufferToWorking = function(pBuffer: PChar; nImportFlags: cuint32): cbool; OVRCALL;
  FnTable_IVRChaperoneSetup_ShowWorkingSetPreview = procedure; OVRCALL;
  FnTable_IVRChaperoneSetup_HideWorkingSetPreview = procedure; OVRCALL;
  FnTable_IVRChaperoneSetup_RoomSetupStarting = procedure; OVRCALL;

  FnTable_IVRCompositor_SetTrackingSpace = procedure(eOrigin: ETrackingUniverseOrigin); OVRCALL;
  FnTable_IVRCompositor_GetTrackingSpace = function: ETrackingUniverseOrigin; OVRCALL;
  FnTable_IVRCompositor_WaitGetPoses = function(pRenderPoseArray: Pointer {TrackedDevicePose_t}; unRenderPoseArrayCount: cuint32; pGamePoseArray: Pointer {TrackedDevicePose_t}; unGamePoseArrayCount: cuint32): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_GetLastPoses = function(pRenderPoseArray: Pointer {TrackedDevicePose_t}; unRenderPoseArrayCount: cuint32; pGamePoseArray: Pointer {TrackedDevicePose_t}; unGamePoseArrayCount: cuint32): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_GetLastPoseForTrackedDeviceIndex = function(unDeviceIndex: TrackedDeviceIndex_t; pOutputPose: Pointer {TrackedDevicePose_t}; pOutputGamePose: Pointer {TrackedDevicePose_t}): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_Submit = function(eEye: EVREye; pTexture: Pointer {Texture_t}; pBounds: Pointer {VRTextureBounds_t}; nSubmitFlags: EVRSubmitFlags): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_ClearLastSubmittedFrame = procedure; OVRCALL;
  FnTable_IVRCompositor_PostPresentHandoff = procedure; OVRCALL;
  FnTable_IVRCompositor_GetFrameTiming = function(pTiming: Pointer {Compositor_FrameTiming}; unFramesAgo: cuint32): cbool; OVRCALL;
  FnTable_IVRCompositor_GetFrameTimings = function(pTiming: Pointer {Compositor_FrameTiming}; nFrames: cuint32): cuint32; OVRCALL;
  FnTable_IVRCompositor_GetFrameTimeRemaining = function: cfloat; OVRCALL;
  FnTable_IVRCompositor_GetCumulativeStats = procedure(pStats: Pointer {Compositor_CumulativeStats}; nStatsSizeInBytes: cuint32); OVRCALL;
  FnTable_IVRCompositor_FadeToColor = procedure(fSeconds: cfloat; fRed: cfloat; fGreen: cfloat; fBlue: cfloat; fAlpha: cfloat; bBackground: cbool); OVRCALL;
  FnTable_IVRCompositor_GetCurrentFadeColor = function(bBackground: cbool): HmdColor_t; OVRCALL;
  FnTable_IVRCompositor_FadeGrid = procedure(fSeconds: cfloat; bFadeIn: cbool); OVRCALL;
  FnTable_IVRCompositor_GetCurrentGridAlpha = function: cfloat; OVRCALL;
  FnTable_IVRCompositor_SetSkyboxOverride = function(pTextures: Pointer {Texture_t}; unTextureCount: cuint32): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_ClearSkyboxOverride = procedure; OVRCALL;
  FnTable_IVRCompositor_CompositorBringToFront = procedure; OVRCALL;
  FnTable_IVRCompositor_CompositorGoToBack = procedure; OVRCALL;
  FnTable_IVRCompositor_CompositorQuit = procedure; OVRCALL;
  FnTable_IVRCompositor_IsFullscreen = function: cbool; OVRCALL;
  FnTable_IVRCompositor_GetCurrentSceneFocusProcess = function: cuint32; OVRCALL;
  FnTable_IVRCompositor_GetLastFrameRenderer = function: cuint32; OVRCALL;
  FnTable_IVRCompositor_CanRenderScene = function: cbool; OVRCALL;
  FnTable_IVRCompositor_ShowMirrorWindow = procedure; OVRCALL;
  FnTable_IVRCompositor_HideMirrorWindow = procedure; OVRCALL;
  FnTable_IVRCompositor_IsMirrorWindowVisible = function: cbool; OVRCALL;
  FnTable_IVRCompositor_CompositorDumpImages = procedure; OVRCALL;
  FnTable_IVRCompositor_ShouldAppRenderWithLowResources = function: cbool; OVRCALL;
  FnTable_IVRCompositor_ForceInterleavedReprojectionOn = procedure(bOverride: cbool); OVRCALL;
  FnTable_IVRCompositor_ForceReconnectProcess = procedure; OVRCALL;
  FnTable_IVRCompositor_SuspendRendering = procedure(bSuspend: cbool); OVRCALL;
  FnTable_IVRCompositor_GetMirrorTextureD3D11 = function(eEye: EVREye; pD3D11DeviceOrResource: Pointer; ppD3D11ShaderResourceView: Pointer {void*}): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_ReleaseMirrorTextureD3D11 = procedure(pD3D11ShaderResourceView: Pointer); OVRCALL;
  FnTable_IVRCompositor_GetMirrorTextureGL = function(eEye: EVREye; pglTextureId: Pointer {glUInt_t}; pglSharedTextureHandle: Pointer {glSharedTextureHandle_t}): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_ReleaseSharedGLTexture = function(glTextureId: glUInt_t; glSharedTextureHandle: glSharedTextureHandle_t): cbool; OVRCALL;
  FnTable_IVRCompositor_LockGLSharedTextureForAccess = procedure(glSharedTextureHandle: glSharedTextureHandle_t); OVRCALL;
  FnTable_IVRCompositor_UnlockGLSharedTextureForAccess = procedure(glSharedTextureHandle: glSharedTextureHandle_t); OVRCALL;
  FnTable_IVRCompositor_GetVulkanInstanceExtensionsRequired = function(pchValue: PChar; unBufferSize: cuint32): cuint32; OVRCALL;
  FnTable_IVRCompositor_GetVulkanDeviceExtensionsRequired = function(pPhysicalDevice: Pointer {VkPhysicalDevice_T}; pchValue: PChar; unBufferSize: cuint32): cuint32; OVRCALL;
  FnTable_IVRCompositor_SetExplicitTimingMode = procedure(eTimingMode: EVRCompositorTimingMode); OVRCALL;
  FnTable_IVRCompositor_SubmitExplicitTimingData = function: EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_IsMotionSmoothingEnabled = function: cbool; OVRCALL;
  FnTable_IVRCompositor_IsMotionSmoothingSupported = function: cbool; OVRCALL;
  FnTable_IVRCompositor_IsCurrentSceneFocusAppLoading = function: cbool; OVRCALL;
  FnTable_IVRCompositor_SetStageOverride_Async = function(pchRenderModelPath: PChar; pTransform: Pointer {HmdMatrix34_t}; pRenderSettings: Pointer {Compositor_StageRenderSettings}; nSizeOfRenderSettings: cuint32): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_ClearStageOverride = procedure; OVRCALL;
  FnTable_IVRCompositor_GetCompositorBenchmarkResults = function(pBenchmarkResults: Pointer {Compositor_BenchmarkResults}; nSizeOfBenchmarkResults: cuint32): cbool; OVRCALL;
  FnTable_IVRCompositor_GetLastPosePredictionIDs = function(pRenderPosePredictionID: Pointer {uint32_t}; pGamePosePredictionID: Pointer {uint32_t}): EVRCompositorError; OVRCALL;
  FnTable_IVRCompositor_GetPosesForFrame = function(unPosePredictionID: cuint32; pPoseArray: Pointer {TrackedDevicePose_t}; unPoseArrayCount: cuint32): EVRCompositorError; OVRCALL;

  FnTable_IVROverlay_FindOverlay = function(pchOverlayKey: PChar; pOverlayHandle: Pointer {VROverlayHandle_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_CreateOverlay = function(pchOverlayKey: PChar; pchOverlayName: PChar; pOverlayHandle: Pointer {VROverlayHandle_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_DestroyOverlay = function(ulOverlayHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayKey = function(ulOverlayHandle: VROverlayHandle_t; pchValue: PChar; unBufferSize: cuint32; pError: Pointer {EVROverlayError}): cuint32; OVRCALL;
  FnTable_IVROverlay_GetOverlayName = function(ulOverlayHandle: VROverlayHandle_t; pchValue: PChar; unBufferSize: cuint32; pError: Pointer {EVROverlayError}): cuint32; OVRCALL;
  FnTable_IVROverlay_SetOverlayName = function(ulOverlayHandle: VROverlayHandle_t; pchName: PChar): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayImageData = function(ulOverlayHandle: VROverlayHandle_t; pvBuffer: Pointer; unBufferSize: cuint32; punWidth: Pointer {uint32_t}; punHeight: Pointer {uint32_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayErrorNameFromEnum = function(error: EVROverlayError): PChar; OVRCALL;
  FnTable_IVROverlay_SetOverlayRenderingPid = function(ulOverlayHandle: VROverlayHandle_t; unPID: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayRenderingPid = function(ulOverlayHandle: VROverlayHandle_t): cuint32; OVRCALL;
  FnTable_IVROverlay_SetOverlayFlag = function(ulOverlayHandle: VROverlayHandle_t; eOverlayFlag: VROverlayFlags; bEnabled: cbool): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayFlag = function(ulOverlayHandle: VROverlayHandle_t; eOverlayFlag: VROverlayFlags; pbEnabled: Pointer {bool}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayFlags = function(ulOverlayHandle: VROverlayHandle_t; pFlags: Pointer {uint32_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayColor = function(ulOverlayHandle: VROverlayHandle_t; fRed: cfloat; fGreen: cfloat; fBlue: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayColor = function(ulOverlayHandle: VROverlayHandle_t; pfRed: Pointer {float}; pfGreen: Pointer {float}; pfBlue: Pointer {float}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayAlpha = function(ulOverlayHandle: VROverlayHandle_t; fAlpha: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayAlpha = function(ulOverlayHandle: VROverlayHandle_t; pfAlpha: Pointer {float}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTexelAspect = function(ulOverlayHandle: VROverlayHandle_t; fTexelAspect: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTexelAspect = function(ulOverlayHandle: VROverlayHandle_t; pfTexelAspect: Pointer {float}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlaySortOrder = function(ulOverlayHandle: VROverlayHandle_t; unSortOrder: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlaySortOrder = function(ulOverlayHandle: VROverlayHandle_t; punSortOrder: Pointer {uint32_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayWidthInMeters = function(ulOverlayHandle: VROverlayHandle_t; fWidthInMeters: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayWidthInMeters = function(ulOverlayHandle: VROverlayHandle_t; pfWidthInMeters: Pointer {float}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayCurvature = function(ulOverlayHandle: VROverlayHandle_t; fCurvature: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayCurvature = function(ulOverlayHandle: VROverlayHandle_t; pfCurvature: Pointer {float}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTextureColorSpace = function(ulOverlayHandle: VROverlayHandle_t; eTextureColorSpace: EColorSpace): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTextureColorSpace = function(ulOverlayHandle: VROverlayHandle_t; peTextureColorSpace: Pointer {EColorSpace}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTextureBounds = function(ulOverlayHandle: VROverlayHandle_t; pOverlayTextureBounds: Pointer {VRTextureBounds_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTextureBounds = function(ulOverlayHandle: VROverlayHandle_t; pOverlayTextureBounds: Pointer {VRTextureBounds_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformType = function(ulOverlayHandle: VROverlayHandle_t; peTransformType: Pointer {VROverlayTransformType}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTransformAbsolute = function(ulOverlayHandle: VROverlayHandle_t; eTrackingOrigin: ETrackingUniverseOrigin; pmatTrackingOriginToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformAbsolute = function(ulOverlayHandle: VROverlayHandle_t; peTrackingOrigin: Pointer {ETrackingUniverseOrigin}; pmatTrackingOriginToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTransformTrackedDeviceRelative = function(ulOverlayHandle: VROverlayHandle_t; unTrackedDevice: TrackedDeviceIndex_t; pmatTrackedDeviceToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformTrackedDeviceRelative = function(ulOverlayHandle: VROverlayHandle_t; punTrackedDevice: Pointer {TrackedDeviceIndex_t}; pmatTrackedDeviceToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTransformTrackedDeviceComponent = function(ulOverlayHandle: VROverlayHandle_t; unDeviceIndex: TrackedDeviceIndex_t; pchComponentName: PChar): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformTrackedDeviceComponent = function(ulOverlayHandle: VROverlayHandle_t; punDeviceIndex: Pointer {TrackedDeviceIndex_t}; pchComponentName: PChar; unComponentNameSize: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformOverlayRelative = function(ulOverlayHandle: VROverlayHandle_t; ulOverlayHandleParent: Pointer {VROverlayHandle_t}; pmatParentOverlayToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTransformOverlayRelative = function(ulOverlayHandle: VROverlayHandle_t; ulOverlayHandleParent: VROverlayHandle_t; pmatParentOverlayToOverlayTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTransformCursor = function(ulCursorOverlayHandle: VROverlayHandle_t; pvHotspot: Pointer {HmdVector2_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTransformCursor = function(ulOverlayHandle: VROverlayHandle_t; pvHotspot: Pointer {HmdVector2_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ShowOverlay = function(ulOverlayHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_HideOverlay = function(ulOverlayHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_IsOverlayVisible = function(ulOverlayHandle: VROverlayHandle_t): cbool; OVRCALL;
  FnTable_IVROverlay_GetTransformForOverlayCoordinates = function(ulOverlayHandle: VROverlayHandle_t; eTrackingOrigin: ETrackingUniverseOrigin; coordinatesInOverlay: HmdVector2_t; pmatTransform: Pointer {HmdMatrix34_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_PollNextOverlayEvent = function(ulOverlayHandle: VROverlayHandle_t; pEvent: Pointer {VREvent_t}; uncbVREvent: cuint32): cbool; OVRCALL;
  FnTable_IVROverlay_GetOverlayInputMethod = function(ulOverlayHandle: VROverlayHandle_t; peInputMethod: Pointer {VROverlayInputMethod}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayInputMethod = function(ulOverlayHandle: VROverlayHandle_t; eInputMethod: VROverlayInputMethod): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayMouseScale = function(ulOverlayHandle: VROverlayHandle_t; pvecMouseScale: Pointer {HmdVector2_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayMouseScale = function(ulOverlayHandle: VROverlayHandle_t; pvecMouseScale: Pointer {HmdVector2_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ComputeOverlayIntersection = function(ulOverlayHandle: VROverlayHandle_t; pParams: Pointer {VROverlayIntersectionParams_t}; pResults: Pointer {VROverlayIntersectionResults_t}): cbool; OVRCALL;
  FnTable_IVROverlay_IsHoverTargetOverlay = function(ulOverlayHandle: VROverlayHandle_t): cbool; OVRCALL;
  FnTable_IVROverlay_SetOverlayIntersectionMask = function(ulOverlayHandle: VROverlayHandle_t; pMaskPrimitives: Pointer {VROverlayIntersectionMaskPrimitive_t}; unNumMaskPrimitives: cuint32; unPrimitiveSize: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_TriggerLaserMouseHapticVibration = function(ulOverlayHandle: VROverlayHandle_t; fDurationSeconds: cfloat; fFrequency: cfloat; fAmplitude: cfloat): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayCursor = function(ulOverlayHandle: VROverlayHandle_t; ulCursorHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayCursorPositionOverride = function(ulOverlayHandle: VROverlayHandle_t; pvCursor: Pointer {HmdVector2_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ClearOverlayCursorPositionOverride = function(ulOverlayHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayTexture = function(ulOverlayHandle: VROverlayHandle_t; pTexture: Pointer {Texture_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ClearOverlayTexture = function(ulOverlayHandle: VROverlayHandle_t): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayRaw = function(ulOverlayHandle: VROverlayHandle_t; pvBuffer: Pointer; unWidth: cuint32; unHeight: cuint32; unBytesPerPixel: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_SetOverlayFromFile = function(ulOverlayHandle: VROverlayHandle_t; pchFilePath: PChar): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTexture = function(ulOverlayHandle: VROverlayHandle_t; pNativeTextureHandle: Pointer {void*}; pNativeTextureRef: Pointer; pWidth: Pointer {uint32_t}; pHeight: Pointer {uint32_t}; pNativeFormat: Pointer {uint32_t}; pAPIType: Pointer {ETextureType}; pColorSpace: Pointer {EColorSpace}; pTextureBounds: Pointer {VRTextureBounds_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ReleaseNativeOverlayHandle = function(ulOverlayHandle: VROverlayHandle_t; pNativeTextureHandle: Pointer): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetOverlayTextureSize = function(ulOverlayHandle: VROverlayHandle_t; pWidth: Pointer {uint32_t}; pHeight: Pointer {uint32_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_CreateDashboardOverlay = function(pchOverlayKey: PChar; pchOverlayFriendlyName: PChar; pMainHandle: Pointer {VROverlayHandle_t}; pThumbnailHandle: Pointer {VROverlayHandle_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_IsDashboardVisible = function: cbool; OVRCALL;
  FnTable_IVROverlay_IsActiveDashboardOverlay = function(ulOverlayHandle: VROverlayHandle_t): cbool; OVRCALL;
  FnTable_IVROverlay_SetDashboardOverlaySceneProcess = function(ulOverlayHandle: VROverlayHandle_t; unProcessId: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetDashboardOverlaySceneProcess = function(ulOverlayHandle: VROverlayHandle_t; punProcessId: Pointer {uint32_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ShowDashboard = procedure(pchOverlayToShow: PChar); OVRCALL;
  FnTable_IVROverlay_GetPrimaryDashboardDevice = function: TrackedDeviceIndex_t; OVRCALL;
  FnTable_IVROverlay_ShowKeyboard = function(eInputMode: EGamepadTextInputMode; eLineInputMode: EGamepadTextInputLineMode; unFlags: cuint32; pchDescription: PChar; unCharMax: cuint32; pchExistingText: PChar; uUserValue: cuint64): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_ShowKeyboardForOverlay = function(ulOverlayHandle: VROverlayHandle_t; eInputMode: EGamepadTextInputMode; eLineInputMode: EGamepadTextInputLineMode; unFlags: cuint32; pchDescription: PChar; unCharMax: cuint32; pchExistingText: PChar; uUserValue: cuint64): EVROverlayError; OVRCALL;
  FnTable_IVROverlay_GetKeyboardText = function(pchText: PChar; cchText: cuint32): cuint32; OVRCALL;
  FnTable_IVROverlay_HideKeyboard = procedure; OVRCALL;
  FnTable_IVROverlay_SetKeyboardTransformAbsolute = procedure(eTrackingOrigin: ETrackingUniverseOrigin; pmatTrackingOriginToKeyboardTransform: Pointer {HmdMatrix34_t}); OVRCALL;
  FnTable_IVROverlay_SetKeyboardPositionForOverlay = procedure(ulOverlayHandle: VROverlayHandle_t; avoidRect: HmdRect2_t); OVRCALL;
  FnTable_IVROverlay_ShowMessageOverlay = function(pchText: PChar; pchCaption: PChar; pchButton0Text: PChar; pchButton1Text: PChar; pchButton2Text: PChar; pchButton3Text: PChar): VRMessageOverlayResponse; OVRCALL;
  FnTable_IVROverlay_CloseMessageOverlay = procedure; OVRCALL;

  FnTable_IVROverlayView_AcquireOverlayView = function(ulOverlayHandle: VROverlayHandle_t; pNativeDevice: Pointer {VRNativeDevice_t}; pOverlayView: Pointer {VROverlayView_t}; unOverlayViewSize: cuint32): EVROverlayError; OVRCALL;
  FnTable_IVROverlayView_ReleaseOverlayView = function(pOverlayView: Pointer {VROverlayView_t}): EVROverlayError; OVRCALL;
  FnTable_IVROverlayView_PostOverlayEvent = procedure(ulOverlayHandle: VROverlayHandle_t; pvrEvent: Pointer {VREvent_t}); OVRCALL;
  FnTable_IVROverlayView_IsViewingPermitted = function(ulOverlayHandle: VROverlayHandle_t): cbool; OVRCALL;

  FnTable_IVRHeadsetView_SetHeadsetViewSize = procedure(nWidth: cuint32; nHeight: cuint32); OVRCALL;
  FnTable_IVRHeadsetView_GetHeadsetViewSize = procedure(pnWidth: Pointer {uint32_t}; pnHeight: Pointer {uint32_t}); OVRCALL;
  FnTable_IVRHeadsetView_SetHeadsetViewMode = procedure(eHeadsetViewMode: HeadsetViewMode_t); OVRCALL;
  FnTable_IVRHeadsetView_GetHeadsetViewMode = function: HeadsetViewMode_t; OVRCALL;
  FnTable_IVRHeadsetView_SetHeadsetViewCropped = procedure(bCropped: cbool); OVRCALL;
  FnTable_IVRHeadsetView_GetHeadsetViewCropped = function: cbool; OVRCALL;
  FnTable_IVRHeadsetView_GetHeadsetViewAspectRatio = function: cfloat; OVRCALL;
  FnTable_IVRHeadsetView_SetHeadsetViewBlendRange = procedure(flStartPct: cfloat; flEndPct: cfloat); OVRCALL;
  FnTable_IVRHeadsetView_GetHeadsetViewBlendRange = procedure(pStartPct: Pointer {float}; pEndPct: Pointer {float}); OVRCALL;

  FnTable_IVRRenderModels_LoadRenderModel_Async = function(pchRenderModelName: PChar; ppRenderModel: Pointer {RenderModel_t*}): EVRRenderModelError; OVRCALL;
  FnTable_IVRRenderModels_FreeRenderModel = procedure(pRenderModel: Pointer {RenderModel_t}); OVRCALL;
  FnTable_IVRRenderModels_LoadTexture_Async = function(textureId: TextureID_t; ppTexture: Pointer {RenderModel_TextureMap_t*}): EVRRenderModelError; OVRCALL;
  FnTable_IVRRenderModels_FreeTexture = procedure(pTexture: Pointer {RenderModel_TextureMap_t}); OVRCALL;
  FnTable_IVRRenderModels_LoadTextureD3D11_Async = function(textureId: TextureID_t; pD3D11Device: Pointer; ppD3D11Texture2D: Pointer {void*}): EVRRenderModelError; OVRCALL;
  FnTable_IVRRenderModels_LoadIntoTextureD3D11_Async = function(textureId: TextureID_t; pDstTexture: Pointer): EVRRenderModelError; OVRCALL;
  FnTable_IVRRenderModels_FreeTextureD3D11 = procedure(pD3D11Texture2D: Pointer); OVRCALL;
  FnTable_IVRRenderModels_GetRenderModelName = function(unRenderModelIndex: cuint32; pchRenderModelName: PChar; unRenderModelNameLen: cuint32): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetRenderModelCount = function: cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetComponentCount = function(pchRenderModelName: PChar): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetComponentName = function(pchRenderModelName: PChar; unComponentIndex: cuint32; pchComponentName: PChar; unComponentNameLen: cuint32): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetComponentButtonMask = function(pchRenderModelName: PChar; pchComponentName: PChar): cuint64; OVRCALL;
  FnTable_IVRRenderModels_GetComponentRenderModelName = function(pchRenderModelName: PChar; pchComponentName: PChar; pchComponentRenderModelName: PChar; unComponentRenderModelNameLen: cuint32): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetComponentStateForDevicePath = function(pchRenderModelName: PChar; pchComponentName: PChar; devicePath: VRInputValueHandle_t; pState: Pointer {RenderModel_ControllerMode_State_t}; pComponentState: Pointer {RenderModel_ComponentState_t}): cbool; OVRCALL;
  FnTable_IVRRenderModels_GetComponentState = function(pchRenderModelName: PChar; pchComponentName: PChar; pControllerState: Pointer {VRControllerState_t}; pState: Pointer {RenderModel_ControllerMode_State_t}; pComponentState: Pointer {RenderModel_ComponentState_t}): cbool; OVRCALL;
  FnTable_IVRRenderModels_RenderModelHasComponent = function(pchRenderModelName: PChar; pchComponentName: PChar): cbool; OVRCALL;
  FnTable_IVRRenderModels_GetRenderModelThumbnailURL = function(pchRenderModelName: PChar; pchThumbnailURL: PChar; unThumbnailURLLen: cuint32; peError: Pointer {EVRRenderModelError}): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetRenderModelOriginalPath = function(pchRenderModelName: PChar; pchOriginalPath: PChar; unOriginalPathLen: cuint32; peError: Pointer {EVRRenderModelError}): cuint32; OVRCALL;
  FnTable_IVRRenderModels_GetRenderModelErrorNameFromEnum = function(error: EVRRenderModelError): PChar; OVRCALL;

  FnTable_IVRNotifications_CreateNotification = function(ulOverlayHandle: VROverlayHandle_t; ulUserValue: cuint64; type_: EVRNotificationType; pchText: PChar; style: EVRNotificationStyle; pImage: Pointer {NotificationBitmap_t}; pNotificationId: Pointer {VRNotificationId}): EVRNotificationError; OVRCALL;
  FnTable_IVRNotifications_RemoveNotification = function(notificationId: VRNotificationId): EVRNotificationError; OVRCALL;

  FnTable_IVRSettings_GetSettingsErrorNameFromEnum = function(eError: EVRSettingsError): PChar; OVRCALL;
  FnTable_IVRSettings_SetBool = procedure(pchSection: PChar; pchSettingsKey: PChar; bValue: cbool; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_SetInt32 = procedure(pchSection: PChar; pchSettingsKey: PChar; nValue: cint32; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_SetFloat = procedure(pchSection: PChar; pchSettingsKey: PChar; flValue: cfloat; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_SetString = procedure(pchSection: PChar; pchSettingsKey: PChar; pchValue: PChar; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_GetBool = function(pchSection: PChar; pchSettingsKey: PChar; peError: Pointer {EVRSettingsError}): cbool; OVRCALL;
  FnTable_IVRSettings_GetInt32 = function(pchSection: PChar; pchSettingsKey: PChar; peError: Pointer {EVRSettingsError}): cint32; OVRCALL;
  FnTable_IVRSettings_GetFloat = function(pchSection: PChar; pchSettingsKey: PChar; peError: Pointer {EVRSettingsError}): cfloat; OVRCALL;
  FnTable_IVRSettings_GetString = procedure(pchSection: PChar; pchSettingsKey: PChar; pchValue: PChar; unValueLen: cuint32; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_RemoveSection = procedure(pchSection: PChar; peError: Pointer {EVRSettingsError}); OVRCALL;
  FnTable_IVRSettings_RemoveKeyInSection = procedure(pchSection: PChar; pchSettingsKey: PChar; peError: Pointer {EVRSettingsError}); OVRCALL;

  FnTable_IVRScreenshots_RequestScreenshot = function(pOutScreenshotHandle: Pointer {ScreenshotHandle_t}; type_: EVRScreenshotType; pchPreviewFilename: PChar; pchVRFilename: PChar): EVRScreenshotError; OVRCALL;
  FnTable_IVRScreenshots_HookScreenshot = function(pSupportedTypes: Pointer {EVRScreenshotType}; numTypes: Integer): EVRScreenshotError; OVRCALL;
  FnTable_IVRScreenshots_GetScreenshotPropertyType = function(screenshotHandle: ScreenshotHandle_t; pError: Pointer {EVRScreenshotError}): EVRScreenshotType; OVRCALL;
  FnTable_IVRScreenshots_GetScreenshotPropertyFilename = function(screenshotHandle: ScreenshotHandle_t; filenameType: EVRScreenshotPropertyFilenames; pchFilename: PChar; cchFilename: cuint32; pError: Pointer {EVRScreenshotError}): cuint32; OVRCALL;
  FnTable_IVRScreenshots_UpdateScreenshotProgress = function(screenshotHandle: ScreenshotHandle_t; flProgress: cfloat): EVRScreenshotError; OVRCALL;
  FnTable_IVRScreenshots_TakeStereoScreenshot = function(pOutScreenshotHandle: Pointer {ScreenshotHandle_t}; pchPreviewFilename: PChar; pchVRFilename: PChar): EVRScreenshotError; OVRCALL;
  FnTable_IVRScreenshots_SubmitScreenshot = function(screenshotHandle: ScreenshotHandle_t; type_: EVRScreenshotType; pchSourcePreviewFilename: PChar; pchSourceVRFilename: PChar): EVRScreenshotError; OVRCALL;

  FnTable_IVRResources_LoadSharedResource = function(pchResourceName: PChar; pchBuffer: PChar; unBufferLen: cuint32): cuint32; OVRCALL;
  FnTable_IVRResources_GetResourceFullPath = function(pchResourceName: PChar; pchResourceTypeDirectory: PChar; pchPathBuffer: PChar; unBufferLen: cuint32): cuint32; OVRCALL;

  FnTable_IVRDriverManager_GetDriverCount = function: cuint32; OVRCALL;
  FnTable_IVRDriverManager_GetDriverName = function(nDriver: DriverId_t; pchValue: PChar; unBufferSize: cuint32): cuint32; OVRCALL;
  FnTable_IVRDriverManager_GetDriverHandle = function(pchDriverName: PChar): DriverHandle_t; OVRCALL;
  FnTable_IVRDriverManager_IsEnabled = function(nDriver: DriverId_t): cbool; OVRCALL;

  FnTable_IVRInput_SetActionManifestPath = function(pchActionManifestPath: PChar): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetActionSetHandle = function(pchActionSetName: PChar; pHandle: Pointer {VRActionSetHandle_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetActionHandle = function(pchActionName: PChar; pHandle: Pointer {VRActionHandle_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetInputSourceHandle = function(pchInputSourcePath: PChar; pHandle: Pointer {VRInputValueHandle_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_UpdateActionState = function(pSets: Pointer {VRActiveActionSet_t}; unSizeOfVRSelectedActionSet_t: cuint32; unSetCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetDigitalActionData = function(action: VRActionHandle_t; pActionData: Pointer {InputDigitalActionData_t}; unActionDataSize: cuint32; ulRestrictToDevice: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetAnalogActionData = function(action: VRActionHandle_t; pActionData: Pointer {InputAnalogActionData_t}; unActionDataSize: cuint32; ulRestrictToDevice: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetPoseActionDataRelativeToNow = function(action: VRActionHandle_t; eOrigin: ETrackingUniverseOrigin; fPredictedSecondsFromNow: cfloat; pActionData: Pointer {InputPoseActionData_t}; unActionDataSize: cuint32; ulRestrictToDevice: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetPoseActionDataForNextFrame = function(action: VRActionHandle_t; eOrigin: ETrackingUniverseOrigin; pActionData: Pointer {InputPoseActionData_t}; unActionDataSize: cuint32; ulRestrictToDevice: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalActionData = function(action: VRActionHandle_t; pActionData: Pointer {InputSkeletalActionData_t}; unActionDataSize: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetDominantHand = function(peDominantHand: Pointer {ETrackedControllerRole}): EVRInputError; OVRCALL;
  FnTable_IVRInput_SetDominantHand = function(eDominantHand: ETrackedControllerRole): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetBoneCount = function(action: VRActionHandle_t; pBoneCount: Pointer {uint32_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetBoneHierarchy = function(action: VRActionHandle_t; pParentIndices: Pointer {BoneIndex_t}; unIndexArayCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetBoneName = function(action: VRActionHandle_t; nBoneIndex: BoneIndex_t; pchBoneName: PChar; unNameBufferSize: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalReferenceTransforms = function(action: VRActionHandle_t; eTransformSpace: EVRSkeletalTransformSpace; eReferencePose: EVRSkeletalReferencePose; pTransformArray: Pointer {VRBoneTransform_t}; unTransformArrayCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalTrackingLevel = function(action: VRActionHandle_t; pSkeletalTrackingLevel: Pointer {EVRSkeletalTrackingLevel}): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalBoneData = function(action: VRActionHandle_t; eTransformSpace: EVRSkeletalTransformSpace; eMotionRange: EVRSkeletalMotionRange; pTransformArray: Pointer {VRBoneTransform_t}; unTransformArrayCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalSummaryData = function(action: VRActionHandle_t; eSummaryType: EVRSummaryType; pSkeletalSummaryData: Pointer {VRSkeletalSummaryData_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetSkeletalBoneDataCompressed = function(action: VRActionHandle_t; eMotionRange: EVRSkeletalMotionRange; pvCompressedData: Pointer; unCompressedSize: cuint32; punRequiredCompressedSize: Pointer {uint32_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_DecompressSkeletalBoneData = function(pvCompressedBuffer: Pointer; unCompressedBufferSize: cuint32; eTransformSpace: EVRSkeletalTransformSpace; pTransformArray: Pointer {VRBoneTransform_t}; unTransformArrayCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_TriggerHapticVibrationAction = function(action: VRActionHandle_t; fStartSecondsFromNow: cfloat; fDurationSeconds: cfloat; fFrequency: cfloat; fAmplitude: cfloat; ulRestrictToDevice: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetActionOrigins = function(actionSetHandle: VRActionSetHandle_t; digitalActionHandle: VRActionHandle_t; originsOut: Pointer {VRInputValueHandle_t}; originOutCount: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetOriginLocalizedName = function(origin: VRInputValueHandle_t; pchNameArray: PChar; unNameArraySize: cuint32; unStringSectionsToInclude: cint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetOriginTrackedDeviceInfo = function(origin: VRInputValueHandle_t; pOriginInfo: Pointer {InputOriginInfo_t}; unOriginInfoSize: cuint32): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetActionBindingInfo = function(action: VRActionHandle_t; pOriginInfo: Pointer {InputBindingInfo_t}; unBindingInfoSize: cuint32; unBindingInfoCount: cuint32; punReturnedBindingInfoCount: Pointer {uint32_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_ShowActionOrigins = function(actionSetHandle: VRActionSetHandle_t; ulActionHandle: VRActionHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_ShowBindingsForActionSet = function(pSets: Pointer {VRActiveActionSet_t}; unSizeOfVRSelectedActionSet_t: cuint32; unSetCount: cuint32; originToHighlight: VRInputValueHandle_t): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetComponentStateForBinding = function(pchRenderModelName: PChar; pchComponentName: PChar; pOriginInfo: Pointer {InputBindingInfo_t}; unBindingInfoSize: cuint32; unBindingInfoCount: cuint32; pComponentState: Pointer {RenderModel_ComponentState_t}): EVRInputError; OVRCALL;
  FnTable_IVRInput_IsUsingLegacyInput = function: cbool; OVRCALL;
  FnTable_IVRInput_OpenBindingUI = function(pchAppKey: PChar; ulActionSetHandle: VRActionSetHandle_t; ulDeviceHandle: VRInputValueHandle_t; bShowOnDesktop: cbool): EVRInputError; OVRCALL;
  FnTable_IVRInput_GetBindingVariant = function(ulDevicePath: VRInputValueHandle_t; pchVariantArray: PChar; unVariantArraySize: cuint32): EVRInputError; OVRCALL;

  FnTable_IVRIOBuffer_Open = function(pchPath: PChar; mode: EIOBufferMode; unElementSize: cuint32; unElements: cuint32; pulBuffer: Pointer {IOBufferHandle_t}): EIOBufferError; OVRCALL;
  FnTable_IVRIOBuffer_Close = function(ulBuffer: IOBufferHandle_t): EIOBufferError; OVRCALL;
  FnTable_IVRIOBuffer_Read = function(ulBuffer: IOBufferHandle_t; pDst: Pointer; unBytes: cuint32; punRead: Pointer {uint32_t}): EIOBufferError; OVRCALL;
  FnTable_IVRIOBuffer_Write = function(ulBuffer: IOBufferHandle_t; pSrc: Pointer; unBytes: cuint32): EIOBufferError; OVRCALL;
  FnTable_IVRIOBuffer_PropertyContainer = function(ulBuffer: IOBufferHandle_t): PropertyContainerHandle_t; OVRCALL;
  FnTable_IVRIOBuffer_HasReaders = function(ulBuffer: IOBufferHandle_t): cbool; OVRCALL;

  FnTable_IVRSpatialAnchors_CreateSpatialAnchorFromDescriptor = function(pchDescriptor: PChar; pHandleOut: Pointer {SpatialAnchorHandle_t}): EVRSpatialAnchorError; OVRCALL;
  FnTable_IVRSpatialAnchors_CreateSpatialAnchorFromPose = function(unDeviceIndex: TrackedDeviceIndex_t; eOrigin: ETrackingUniverseOrigin; pPose: Pointer {SpatialAnchorPose_t}; pHandleOut: Pointer {SpatialAnchorHandle_t}): EVRSpatialAnchorError; OVRCALL;
  FnTable_IVRSpatialAnchors_GetSpatialAnchorPose = function(unHandle: SpatialAnchorHandle_t; eOrigin: ETrackingUniverseOrigin; pPoseOut: Pointer {SpatialAnchorPose_t}): EVRSpatialAnchorError; OVRCALL;
  FnTable_IVRSpatialAnchors_GetSpatialAnchorDescriptor = function(unHandle: SpatialAnchorHandle_t; pchDescriptorOut: PChar; punDescriptorBufferLenInOut: Pointer {uint32_t}): EVRSpatialAnchorError; OVRCALL;

  FnTable_IVRDebug_EmitVrProfilerEvent = function(pchMessage: PChar): EVRDebugError; OVRCALL;
  FnTable_IVRDebug_BeginVrProfilerEvent = function(pHandleOut: Pointer {VrProfilerEventHandle_t}): EVRDebugError; OVRCALL;
  FnTable_IVRDebug_FinishVrProfilerEvent = function(hHandle: VrProfilerEventHandle_t; pchMessage: PChar): EVRDebugError; OVRCALL;
  FnTable_IVRDebug_DriverDebugRequest = function(unDeviceIndex: TrackedDeviceIndex_t; pchRequest: PChar; pchResponseBuffer: PChar; unResponseBufferSize: cuint32): cuint32; OVRCALL;

  FnTable_IVRProperties_ReadPropertyBatch = function(ulContainerHandle: PropertyContainerHandle_t; pBatch: Pointer {PropertyRead_t}; unBatchEntryCount: cuint32): ETrackedPropertyError; OVRCALL;
  FnTable_IVRProperties_WritePropertyBatch = function(ulContainerHandle: PropertyContainerHandle_t; pBatch: Pointer {PropertyWrite_t}; unBatchEntryCount: cuint32): ETrackedPropertyError; OVRCALL;
  FnTable_IVRProperties_GetPropErrorNameFromEnum = function(error: ETrackedPropertyError): PChar; OVRCALL;
  FnTable_IVRProperties_TrackedDeviceToPropertyContainer = function(nDevice: TrackedDeviceIndex_t): PropertyContainerHandle_t; OVRCALL;

  FnTable_IVRPaths_ReadPathBatch = function(ulRootHandle: PropertyContainerHandle_t; pBatch: Pointer {PathRead_t}; unBatchEntryCount: cuint32): ETrackedPropertyError; OVRCALL;
  FnTable_IVRPaths_WritePathBatch = function(ulRootHandle: PropertyContainerHandle_t; pBatch: Pointer {PathWrite_t}; unBatchEntryCount: cuint32): ETrackedPropertyError; OVRCALL;
  FnTable_IVRPaths_StringToHandle = function(pHandle: Pointer {PathHandle_t}; pchPath: PChar): ETrackedPropertyError; OVRCALL;
  FnTable_IVRPaths_HandleToString = function(pHandle: PathHandle_t; pchBuffer: PChar; unBufferSize: cuint32; punBufferSizeUsed: Pointer {uint32_t}): ETrackedPropertyError; OVRCALL;

  FnTable_IVRBlockQueue_Create = function(pulQueueHandle: Pointer {PropertyContainerHandle_t}; pchPath: PChar; unBlockDataSize: cuint32; unBlockHeaderSize: cuint32; unBlockCount: cuint32): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_Connect = function(pulQueueHandle: Pointer {PropertyContainerHandle_t}; pchPath: PChar): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_Destroy = function(ulQueueHandle: PropertyContainerHandle_t): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_AcquireWriteOnlyBlock = function(ulQueueHandle: PropertyContainerHandle_t; pulBlockHandle: Pointer {PropertyContainerHandle_t}; ppvBuffer: Pointer {void*}): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_ReleaseWriteOnlyBlock = function(ulQueueHandle: PropertyContainerHandle_t; ulBlockHandle: PropertyContainerHandle_t): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_WaitAndAcquireReadOnlyBlock = function(ulQueueHandle: PropertyContainerHandle_t; pulBlockHandle: Pointer {PropertyContainerHandle_t}; ppvBuffer: Pointer {void*}; eReadType: EBlockQueueReadType; unTimeoutMs: cuint32): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_AcquireReadOnlyBlock = function(ulQueueHandle: PropertyContainerHandle_t; pulBlockHandle: Pointer {PropertyContainerHandle_t}; ppvBuffer: Pointer {void*}; eReadType: EBlockQueueReadType): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_ReleaseReadOnlyBlock = function(ulQueueHandle: PropertyContainerHandle_t; ulBlockHandle: PropertyContainerHandle_t): EBlockQueueError; OVRCALL;
  FnTable_IVRBlockQueue_QueueHasReader = function(ulQueueHandle: PropertyContainerHandle_t; pbHasReaders: Pointer {bool}): EBlockQueueError; OVRCALL;



  TIVRSystem = record
    GetRecommendedRenderTargetSize: FnTable_IVRSystem_GetRecommendedRenderTargetSize;
    GetProjectionMatrix: FnTable_IVRSystem_GetProjectionMatrix;
    GetProjectionRaw: FnTable_IVRSystem_GetProjectionRaw;
    ComputeDistortion: FnTable_IVRSystem_ComputeDistortion;
    GetEyeToHeadTransform: FnTable_IVRSystem_GetEyeToHeadTransform;
    GetTimeSinceLastVsync: FnTable_IVRSystem_GetTimeSinceLastVsync;
    GetD3D9AdapterIndex: FnTable_IVRSystem_GetD3D9AdapterIndex;
    GetDXGIOutputInfo: FnTable_IVRSystem_GetDXGIOutputInfo;
    GetOutputDevice: FnTable_IVRSystem_GetOutputDevice;
    IsDisplayOnDesktop: FnTable_IVRSystem_IsDisplayOnDesktop;
    SetDisplayVisibility: FnTable_IVRSystem_SetDisplayVisibility;
    GetDeviceToAbsoluteTrackingPose: FnTable_IVRSystem_GetDeviceToAbsoluteTrackingPose;
    GetSeatedZeroPoseToStandingAbsoluteTrackingPose: FnTable_IVRSystem_GetSeatedZeroPoseToStandingAbsoluteTrackingPose;
    GetRawZeroPoseToStandingAbsoluteTrackingPose: FnTable_IVRSystem_GetRawZeroPoseToStandingAbsoluteTrackingPose;
    GetSortedTrackedDeviceIndicesOfClass: FnTable_IVRSystem_GetSortedTrackedDeviceIndicesOfClass;
    GetTrackedDeviceActivityLevel: FnTable_IVRSystem_GetTrackedDeviceActivityLevel;
    ApplyTransform: FnTable_IVRSystem_ApplyTransform;
    GetTrackedDeviceIndexForControllerRole: FnTable_IVRSystem_GetTrackedDeviceIndexForControllerRole;
    GetControllerRoleForTrackedDeviceIndex: FnTable_IVRSystem_GetControllerRoleForTrackedDeviceIndex;
    GetTrackedDeviceClass: FnTable_IVRSystem_GetTrackedDeviceClass;
    IsTrackedDeviceConnected: FnTable_IVRSystem_IsTrackedDeviceConnected;
    GetBoolTrackedDeviceProperty: FnTable_IVRSystem_GetBoolTrackedDeviceProperty;
    GetFloatTrackedDeviceProperty: FnTable_IVRSystem_GetFloatTrackedDeviceProperty;
    GetInt32TrackedDeviceProperty: FnTable_IVRSystem_GetInt32TrackedDeviceProperty;
    GetUint64TrackedDeviceProperty: FnTable_IVRSystem_GetUint64TrackedDeviceProperty;
    GetMatrix34TrackedDeviceProperty: FnTable_IVRSystem_GetMatrix34TrackedDeviceProperty;
    GetArrayTrackedDeviceProperty: FnTable_IVRSystem_GetArrayTrackedDeviceProperty;
    GetStringTrackedDeviceProperty: FnTable_IVRSystem_GetStringTrackedDeviceProperty;
    GetPropErrorNameFromEnum: FnTable_IVRSystem_GetPropErrorNameFromEnum;
    PollNextEvent: FnTable_IVRSystem_PollNextEvent;
    PollNextEventWithPose: FnTable_IVRSystem_PollNextEventWithPose;
    GetEventTypeNameFromEnum: FnTable_IVRSystem_GetEventTypeNameFromEnum;
    GetHiddenAreaMesh: FnTable_IVRSystem_GetHiddenAreaMesh;
    GetControllerState: FnTable_IVRSystem_GetControllerState;
    GetControllerStateWithPose: FnTable_IVRSystem_GetControllerStateWithPose;
    TriggerHapticPulse: FnTable_IVRSystem_TriggerHapticPulse;
    GetButtonIdNameFromEnum: FnTable_IVRSystem_GetButtonIdNameFromEnum;
    GetControllerAxisTypeNameFromEnum: FnTable_IVRSystem_GetControllerAxisTypeNameFromEnum;
    IsInputAvailable: FnTable_IVRSystem_IsInputAvailable;
    IsSteamVRDrawingControllers: FnTable_IVRSystem_IsSteamVRDrawingControllers;
    ShouldApplicationPause: FnTable_IVRSystem_ShouldApplicationPause;
    ShouldApplicationReduceRenderingWork: FnTable_IVRSystem_ShouldApplicationReduceRenderingWork;
    PerformFirmwareUpdate: FnTable_IVRSystem_PerformFirmwareUpdate;
    AcknowledgeQuit_Exiting: FnTable_IVRSystem_AcknowledgeQuit_Exiting;
    GetAppContainerFilePaths: FnTable_IVRSystem_GetAppContainerFilePaths;
    GetRuntimeVersion: FnTable_IVRSystem_GetRuntimeVersion;
  end;
  PIVRSystem = ^TIVRSystem;

  TIVRExtendedDisplay = record
    GetWindowBounds: FnTable_IVRExtendedDisplay_GetWindowBounds;
    GetEyeOutputViewport: FnTable_IVRExtendedDisplay_GetEyeOutputViewport;
    GetDXGIOutputInfo: FnTable_IVRExtendedDisplay_GetDXGIOutputInfo;
  end;
  PIVRExtendedDisplay = ^TIVRExtendedDisplay;

  TIVRTrackedCamera = record
    GetCameraErrorNameFromEnum: FnTable_IVRTrackedCamera_GetCameraErrorNameFromEnum;
    HasCamera: FnTable_IVRTrackedCamera_HasCamera;
    GetCameraFrameSize: FnTable_IVRTrackedCamera_GetCameraFrameSize;
    GetCameraIntrinsics: FnTable_IVRTrackedCamera_GetCameraIntrinsics;
    GetCameraProjection: FnTable_IVRTrackedCamera_GetCameraProjection;
    AcquireVideoStreamingService: FnTable_IVRTrackedCamera_AcquireVideoStreamingService;
    ReleaseVideoStreamingService: FnTable_IVRTrackedCamera_ReleaseVideoStreamingService;
    GetVideoStreamFrameBuffer: FnTable_IVRTrackedCamera_GetVideoStreamFrameBuffer;
    GetVideoStreamTextureSize: FnTable_IVRTrackedCamera_GetVideoStreamTextureSize;
    GetVideoStreamTextureD3D11: FnTable_IVRTrackedCamera_GetVideoStreamTextureD3D11;
    GetVideoStreamTextureGL: FnTable_IVRTrackedCamera_GetVideoStreamTextureGL;
    ReleaseVideoStreamTextureGL: FnTable_IVRTrackedCamera_ReleaseVideoStreamTextureGL;
    SetCameraTrackingSpace: FnTable_IVRTrackedCamera_SetCameraTrackingSpace;
    GetCameraTrackingSpace: FnTable_IVRTrackedCamera_GetCameraTrackingSpace;
  end;
  PIVRTrackedCamera = ^TIVRTrackedCamera;

  TIVRApplications = record
    AddApplicationManifest: FnTable_IVRApplications_AddApplicationManifest;
    RemoveApplicationManifest: FnTable_IVRApplications_RemoveApplicationManifest;
    IsApplicationInstalled: FnTable_IVRApplications_IsApplicationInstalled;
    GetApplicationCount: FnTable_IVRApplications_GetApplicationCount;
    GetApplicationKeyByIndex: FnTable_IVRApplications_GetApplicationKeyByIndex;
    GetApplicationKeyByProcessId: FnTable_IVRApplications_GetApplicationKeyByProcessId;
    LaunchApplication: FnTable_IVRApplications_LaunchApplication;
    LaunchTemplateApplication: FnTable_IVRApplications_LaunchTemplateApplication;
    LaunchApplicationFromMimeType: FnTable_IVRApplications_LaunchApplicationFromMimeType;
    LaunchDashboardOverlay: FnTable_IVRApplications_LaunchDashboardOverlay;
    CancelApplicationLaunch: FnTable_IVRApplications_CancelApplicationLaunch;
    IdentifyApplication: FnTable_IVRApplications_IdentifyApplication;
    GetApplicationProcessId: FnTable_IVRApplications_GetApplicationProcessId;
    GetApplicationsErrorNameFromEnum: FnTable_IVRApplications_GetApplicationsErrorNameFromEnum;
    GetApplicationPropertyString: FnTable_IVRApplications_GetApplicationPropertyString;
    GetApplicationPropertyBool: FnTable_IVRApplications_GetApplicationPropertyBool;
    GetApplicationPropertyUint64: FnTable_IVRApplications_GetApplicationPropertyUint64;
    SetApplicationAutoLaunch: FnTable_IVRApplications_SetApplicationAutoLaunch;
    GetApplicationAutoLaunch: FnTable_IVRApplications_GetApplicationAutoLaunch;
    SetDefaultApplicationForMimeType: FnTable_IVRApplications_SetDefaultApplicationForMimeType;
    GetDefaultApplicationForMimeType: FnTable_IVRApplications_GetDefaultApplicationForMimeType;
    GetApplicationSupportedMimeTypes: FnTable_IVRApplications_GetApplicationSupportedMimeTypes;
    GetApplicationsThatSupportMimeType: FnTable_IVRApplications_GetApplicationsThatSupportMimeType;
    GetApplicationLaunchArguments: FnTable_IVRApplications_GetApplicationLaunchArguments;
    GetStartingApplication: FnTable_IVRApplications_GetStartingApplication;
    GetSceneApplicationState: FnTable_IVRApplications_GetSceneApplicationState;
    PerformApplicationPrelaunchCheck: FnTable_IVRApplications_PerformApplicationPrelaunchCheck;
    GetSceneApplicationStateNameFromEnum: FnTable_IVRApplications_GetSceneApplicationStateNameFromEnum;
    LaunchInternalProcess: FnTable_IVRApplications_LaunchInternalProcess;
    GetCurrentSceneProcessId: FnTable_IVRApplications_GetCurrentSceneProcessId;
  end;
  PIVRApplications = ^TIVRApplications;

  TIVRChaperone = record
    GetCalibrationState: FnTable_IVRChaperone_GetCalibrationState;
    GetPlayAreaSize: FnTable_IVRChaperone_GetPlayAreaSize;
    GetPlayAreaRect: FnTable_IVRChaperone_GetPlayAreaRect;
    ReloadInfo: FnTable_IVRChaperone_ReloadInfo;
    SetSceneColor: FnTable_IVRChaperone_SetSceneColor;
    GetBoundsColor: FnTable_IVRChaperone_GetBoundsColor;
    AreBoundsVisible: FnTable_IVRChaperone_AreBoundsVisible;
    ForceBoundsVisible: FnTable_IVRChaperone_ForceBoundsVisible;
    ResetZeroPose: FnTable_IVRChaperone_ResetZeroPose;
  end;
  PIVRChaperone = ^TIVRChaperone;

  TIVRChaperoneSetup = record
    CommitWorkingCopy: FnTable_IVRChaperoneSetup_CommitWorkingCopy;
    RevertWorkingCopy: FnTable_IVRChaperoneSetup_RevertWorkingCopy;
    GetWorkingPlayAreaSize: FnTable_IVRChaperoneSetup_GetWorkingPlayAreaSize;
    GetWorkingPlayAreaRect: FnTable_IVRChaperoneSetup_GetWorkingPlayAreaRect;
    GetWorkingCollisionBoundsInfo: FnTable_IVRChaperoneSetup_GetWorkingCollisionBoundsInfo;
    GetLiveCollisionBoundsInfo: FnTable_IVRChaperoneSetup_GetLiveCollisionBoundsInfo;
    GetWorkingSeatedZeroPoseToRawTrackingPose: FnTable_IVRChaperoneSetup_GetWorkingSeatedZeroPoseToRawTrackingPose;
    GetWorkingStandingZeroPoseToRawTrackingPose: FnTable_IVRChaperoneSetup_GetWorkingStandingZeroPoseToRawTrackingPose;
    SetWorkingPlayAreaSize: FnTable_IVRChaperoneSetup_SetWorkingPlayAreaSize;
    SetWorkingCollisionBoundsInfo: FnTable_IVRChaperoneSetup_SetWorkingCollisionBoundsInfo;
    SetWorkingPerimeter: FnTable_IVRChaperoneSetup_SetWorkingPerimeter;
    SetWorkingSeatedZeroPoseToRawTrackingPose: FnTable_IVRChaperoneSetup_SetWorkingSeatedZeroPoseToRawTrackingPose;
    SetWorkingStandingZeroPoseToRawTrackingPose: FnTable_IVRChaperoneSetup_SetWorkingStandingZeroPoseToRawTrackingPose;
    ReloadFromDisk: FnTable_IVRChaperoneSetup_ReloadFromDisk;
    GetLiveSeatedZeroPoseToRawTrackingPose: FnTable_IVRChaperoneSetup_GetLiveSeatedZeroPoseToRawTrackingPose;
    ExportLiveToBuffer: FnTable_IVRChaperoneSetup_ExportLiveToBuffer;
    ImportFromBufferToWorking: FnTable_IVRChaperoneSetup_ImportFromBufferToWorking;
    ShowWorkingSetPreview: FnTable_IVRChaperoneSetup_ShowWorkingSetPreview;
    HideWorkingSetPreview: FnTable_IVRChaperoneSetup_HideWorkingSetPreview;
    RoomSetupStarting: FnTable_IVRChaperoneSetup_RoomSetupStarting;
  end;
  PIVRChaperoneSetup = ^TIVRChaperoneSetup;

  TIVRCompositor = record
    SetTrackingSpace: FnTable_IVRCompositor_SetTrackingSpace;
    GetTrackingSpace: FnTable_IVRCompositor_GetTrackingSpace;
    WaitGetPoses: FnTable_IVRCompositor_WaitGetPoses;
    GetLastPoses: FnTable_IVRCompositor_GetLastPoses;
    GetLastPoseForTrackedDeviceIndex: FnTable_IVRCompositor_GetLastPoseForTrackedDeviceIndex;
    Submit: FnTable_IVRCompositor_Submit;
    ClearLastSubmittedFrame: FnTable_IVRCompositor_ClearLastSubmittedFrame;
    PostPresentHandoff: FnTable_IVRCompositor_PostPresentHandoff;
    GetFrameTiming: FnTable_IVRCompositor_GetFrameTiming;
    GetFrameTimings: FnTable_IVRCompositor_GetFrameTimings;
    GetFrameTimeRemaining: FnTable_IVRCompositor_GetFrameTimeRemaining;
    GetCumulativeStats: FnTable_IVRCompositor_GetCumulativeStats;
    FadeToColor: FnTable_IVRCompositor_FadeToColor;
    GetCurrentFadeColor: FnTable_IVRCompositor_GetCurrentFadeColor;
    FadeGrid: FnTable_IVRCompositor_FadeGrid;
    GetCurrentGridAlpha: FnTable_IVRCompositor_GetCurrentGridAlpha;
    SetSkyboxOverride: FnTable_IVRCompositor_SetSkyboxOverride;
    ClearSkyboxOverride: FnTable_IVRCompositor_ClearSkyboxOverride;
    CompositorBringToFront: FnTable_IVRCompositor_CompositorBringToFront;
    CompositorGoToBack: FnTable_IVRCompositor_CompositorGoToBack;
    CompositorQuit: FnTable_IVRCompositor_CompositorQuit;
    IsFullscreen: FnTable_IVRCompositor_IsFullscreen;
    GetCurrentSceneFocusProcess: FnTable_IVRCompositor_GetCurrentSceneFocusProcess;
    GetLastFrameRenderer: FnTable_IVRCompositor_GetLastFrameRenderer;
    CanRenderScene: FnTable_IVRCompositor_CanRenderScene;
    ShowMirrorWindow: FnTable_IVRCompositor_ShowMirrorWindow;
    HideMirrorWindow: FnTable_IVRCompositor_HideMirrorWindow;
    IsMirrorWindowVisible: FnTable_IVRCompositor_IsMirrorWindowVisible;
    CompositorDumpImages: FnTable_IVRCompositor_CompositorDumpImages;
    ShouldAppRenderWithLowResources: FnTable_IVRCompositor_ShouldAppRenderWithLowResources;
    ForceInterleavedReprojectionOn: FnTable_IVRCompositor_ForceInterleavedReprojectionOn;
    ForceReconnectProcess: FnTable_IVRCompositor_ForceReconnectProcess;
    SuspendRendering: FnTable_IVRCompositor_SuspendRendering;
    GetMirrorTextureD3D11: FnTable_IVRCompositor_GetMirrorTextureD3D11;
    ReleaseMirrorTextureD3D11: FnTable_IVRCompositor_ReleaseMirrorTextureD3D11;
    GetMirrorTextureGL: FnTable_IVRCompositor_GetMirrorTextureGL;
    ReleaseSharedGLTexture: FnTable_IVRCompositor_ReleaseSharedGLTexture;
    LockGLSharedTextureForAccess: FnTable_IVRCompositor_LockGLSharedTextureForAccess;
    UnlockGLSharedTextureForAccess: FnTable_IVRCompositor_UnlockGLSharedTextureForAccess;
    GetVulkanInstanceExtensionsRequired: FnTable_IVRCompositor_GetVulkanInstanceExtensionsRequired;
    GetVulkanDeviceExtensionsRequired: FnTable_IVRCompositor_GetVulkanDeviceExtensionsRequired;
    SetExplicitTimingMode: FnTable_IVRCompositor_SetExplicitTimingMode;
    SubmitExplicitTimingData: FnTable_IVRCompositor_SubmitExplicitTimingData;
    IsMotionSmoothingEnabled: FnTable_IVRCompositor_IsMotionSmoothingEnabled;
    IsMotionSmoothingSupported: FnTable_IVRCompositor_IsMotionSmoothingSupported;
    IsCurrentSceneFocusAppLoading: FnTable_IVRCompositor_IsCurrentSceneFocusAppLoading;
    SetStageOverride_Async: FnTable_IVRCompositor_SetStageOverride_Async;
    ClearStageOverride: FnTable_IVRCompositor_ClearStageOverride;
    GetCompositorBenchmarkResults: FnTable_IVRCompositor_GetCompositorBenchmarkResults;
    GetLastPosePredictionIDs: FnTable_IVRCompositor_GetLastPosePredictionIDs;
    GetPosesForFrame: FnTable_IVRCompositor_GetPosesForFrame;
  end;
  PIVRCompositor = ^TIVRCompositor;

  TIVROverlay = record
    FindOverlay: FnTable_IVROverlay_FindOverlay;
    CreateOverlay: FnTable_IVROverlay_CreateOverlay;
    DestroyOverlay: FnTable_IVROverlay_DestroyOverlay;
    GetOverlayKey: FnTable_IVROverlay_GetOverlayKey;
    GetOverlayName: FnTable_IVROverlay_GetOverlayName;
    SetOverlayName: FnTable_IVROverlay_SetOverlayName;
    GetOverlayImageData: FnTable_IVROverlay_GetOverlayImageData;
    GetOverlayErrorNameFromEnum: FnTable_IVROverlay_GetOverlayErrorNameFromEnum;
    SetOverlayRenderingPid: FnTable_IVROverlay_SetOverlayRenderingPid;
    GetOverlayRenderingPid: FnTable_IVROverlay_GetOverlayRenderingPid;
    SetOverlayFlag: FnTable_IVROverlay_SetOverlayFlag;
    GetOverlayFlag: FnTable_IVROverlay_GetOverlayFlag;
    GetOverlayFlags: FnTable_IVROverlay_GetOverlayFlags;
    SetOverlayColor: FnTable_IVROverlay_SetOverlayColor;
    GetOverlayColor: FnTable_IVROverlay_GetOverlayColor;
    SetOverlayAlpha: FnTable_IVROverlay_SetOverlayAlpha;
    GetOverlayAlpha: FnTable_IVROverlay_GetOverlayAlpha;
    SetOverlayTexelAspect: FnTable_IVROverlay_SetOverlayTexelAspect;
    GetOverlayTexelAspect: FnTable_IVROverlay_GetOverlayTexelAspect;
    SetOverlaySortOrder: FnTable_IVROverlay_SetOverlaySortOrder;
    GetOverlaySortOrder: FnTable_IVROverlay_GetOverlaySortOrder;
    SetOverlayWidthInMeters: FnTable_IVROverlay_SetOverlayWidthInMeters;
    GetOverlayWidthInMeters: FnTable_IVROverlay_GetOverlayWidthInMeters;
    SetOverlayCurvature: FnTable_IVROverlay_SetOverlayCurvature;
    GetOverlayCurvature: FnTable_IVROverlay_GetOverlayCurvature;
    SetOverlayTextureColorSpace: FnTable_IVROverlay_SetOverlayTextureColorSpace;
    GetOverlayTextureColorSpace: FnTable_IVROverlay_GetOverlayTextureColorSpace;
    SetOverlayTextureBounds: FnTable_IVROverlay_SetOverlayTextureBounds;
    GetOverlayTextureBounds: FnTable_IVROverlay_GetOverlayTextureBounds;
    GetOverlayTransformType: FnTable_IVROverlay_GetOverlayTransformType;
    SetOverlayTransformAbsolute: FnTable_IVROverlay_SetOverlayTransformAbsolute;
    GetOverlayTransformAbsolute: FnTable_IVROverlay_GetOverlayTransformAbsolute;
    SetOverlayTransformTrackedDeviceRelative: FnTable_IVROverlay_SetOverlayTransformTrackedDeviceRelative;
    GetOverlayTransformTrackedDeviceRelative: FnTable_IVROverlay_GetOverlayTransformTrackedDeviceRelative;
    SetOverlayTransformTrackedDeviceComponent: FnTable_IVROverlay_SetOverlayTransformTrackedDeviceComponent;
    GetOverlayTransformTrackedDeviceComponent: FnTable_IVROverlay_GetOverlayTransformTrackedDeviceComponent;
    GetOverlayTransformOverlayRelative: FnTable_IVROverlay_GetOverlayTransformOverlayRelative;
    SetOverlayTransformOverlayRelative: FnTable_IVROverlay_SetOverlayTransformOverlayRelative;
    SetOverlayTransformCursor: FnTable_IVROverlay_SetOverlayTransformCursor;
    GetOverlayTransformCursor: FnTable_IVROverlay_GetOverlayTransformCursor;
    ShowOverlay: FnTable_IVROverlay_ShowOverlay;
    HideOverlay: FnTable_IVROverlay_HideOverlay;
    IsOverlayVisible: FnTable_IVROverlay_IsOverlayVisible;
    GetTransformForOverlayCoordinates: FnTable_IVROverlay_GetTransformForOverlayCoordinates;
    PollNextOverlayEvent: FnTable_IVROverlay_PollNextOverlayEvent;
    GetOverlayInputMethod: FnTable_IVROverlay_GetOverlayInputMethod;
    SetOverlayInputMethod: FnTable_IVROverlay_SetOverlayInputMethod;
    GetOverlayMouseScale: FnTable_IVROverlay_GetOverlayMouseScale;
    SetOverlayMouseScale: FnTable_IVROverlay_SetOverlayMouseScale;
    ComputeOverlayIntersection: FnTable_IVROverlay_ComputeOverlayIntersection;
    IsHoverTargetOverlay: FnTable_IVROverlay_IsHoverTargetOverlay;
    SetOverlayIntersectionMask: FnTable_IVROverlay_SetOverlayIntersectionMask;
    TriggerLaserMouseHapticVibration: FnTable_IVROverlay_TriggerLaserMouseHapticVibration;
    SetOverlayCursor: FnTable_IVROverlay_SetOverlayCursor;
    SetOverlayCursorPositionOverride: FnTable_IVROverlay_SetOverlayCursorPositionOverride;
    ClearOverlayCursorPositionOverride: FnTable_IVROverlay_ClearOverlayCursorPositionOverride;
    SetOverlayTexture: FnTable_IVROverlay_SetOverlayTexture;
    ClearOverlayTexture: FnTable_IVROverlay_ClearOverlayTexture;
    SetOverlayRaw: FnTable_IVROverlay_SetOverlayRaw;
    SetOverlayFromFile: FnTable_IVROverlay_SetOverlayFromFile;
    GetOverlayTexture: FnTable_IVROverlay_GetOverlayTexture;
    ReleaseNativeOverlayHandle: FnTable_IVROverlay_ReleaseNativeOverlayHandle;
    GetOverlayTextureSize: FnTable_IVROverlay_GetOverlayTextureSize;
    CreateDashboardOverlay: FnTable_IVROverlay_CreateDashboardOverlay;
    IsDashboardVisible: FnTable_IVROverlay_IsDashboardVisible;
    IsActiveDashboardOverlay: FnTable_IVROverlay_IsActiveDashboardOverlay;
    SetDashboardOverlaySceneProcess: FnTable_IVROverlay_SetDashboardOverlaySceneProcess;
    GetDashboardOverlaySceneProcess: FnTable_IVROverlay_GetDashboardOverlaySceneProcess;
    ShowDashboard: FnTable_IVROverlay_ShowDashboard;
    GetPrimaryDashboardDevice: FnTable_IVROverlay_GetPrimaryDashboardDevice;
    ShowKeyboard: FnTable_IVROverlay_ShowKeyboard;
    ShowKeyboardForOverlay: FnTable_IVROverlay_ShowKeyboardForOverlay;
    GetKeyboardText: FnTable_IVROverlay_GetKeyboardText;
    HideKeyboard: FnTable_IVROverlay_HideKeyboard;
    SetKeyboardTransformAbsolute: FnTable_IVROverlay_SetKeyboardTransformAbsolute;
    SetKeyboardPositionForOverlay: FnTable_IVROverlay_SetKeyboardPositionForOverlay;
    ShowMessageOverlay: FnTable_IVROverlay_ShowMessageOverlay;
    CloseMessageOverlay: FnTable_IVROverlay_CloseMessageOverlay;
  end;
  PIVROverlay = ^TIVROverlay;

  TIVROverlayView = record
    AcquireOverlayView: FnTable_IVROverlayView_AcquireOverlayView;
    ReleaseOverlayView: FnTable_IVROverlayView_ReleaseOverlayView;
    PostOverlayEvent: FnTable_IVROverlayView_PostOverlayEvent;
    IsViewingPermitted: FnTable_IVROverlayView_IsViewingPermitted;
  end;
  PIVROverlayView = ^TIVROverlayView;

  TIVRHeadsetView = record
    SetHeadsetViewSize: FnTable_IVRHeadsetView_SetHeadsetViewSize;
    GetHeadsetViewSize: FnTable_IVRHeadsetView_GetHeadsetViewSize;
    SetHeadsetViewMode: FnTable_IVRHeadsetView_SetHeadsetViewMode;
    GetHeadsetViewMode: FnTable_IVRHeadsetView_GetHeadsetViewMode;
    SetHeadsetViewCropped: FnTable_IVRHeadsetView_SetHeadsetViewCropped;
    GetHeadsetViewCropped: FnTable_IVRHeadsetView_GetHeadsetViewCropped;
    GetHeadsetViewAspectRatio: FnTable_IVRHeadsetView_GetHeadsetViewAspectRatio;
    SetHeadsetViewBlendRange: FnTable_IVRHeadsetView_SetHeadsetViewBlendRange;
    GetHeadsetViewBlendRange: FnTable_IVRHeadsetView_GetHeadsetViewBlendRange;
  end;
  PIVRHeadsetView = ^TIVRHeadsetView;

  TIVRRenderModels = record
    LoadRenderModel_Async: FnTable_IVRRenderModels_LoadRenderModel_Async;
    FreeRenderModel: FnTable_IVRRenderModels_FreeRenderModel;
    LoadTexture_Async: FnTable_IVRRenderModels_LoadTexture_Async;
    FreeTexture: FnTable_IVRRenderModels_FreeTexture;
    LoadTextureD3D11_Async: FnTable_IVRRenderModels_LoadTextureD3D11_Async;
    LoadIntoTextureD3D11_Async: FnTable_IVRRenderModels_LoadIntoTextureD3D11_Async;
    FreeTextureD3D11: FnTable_IVRRenderModels_FreeTextureD3D11;
    GetRenderModelName: FnTable_IVRRenderModels_GetRenderModelName;
    GetRenderModelCount: FnTable_IVRRenderModels_GetRenderModelCount;
    GetComponentCount: FnTable_IVRRenderModels_GetComponentCount;
    GetComponentName: FnTable_IVRRenderModels_GetComponentName;
    GetComponentButtonMask: FnTable_IVRRenderModels_GetComponentButtonMask;
    GetComponentRenderModelName: FnTable_IVRRenderModels_GetComponentRenderModelName;
    GetComponentStateForDevicePath: FnTable_IVRRenderModels_GetComponentStateForDevicePath;
    GetComponentState: FnTable_IVRRenderModels_GetComponentState;
    RenderModelHasComponent: FnTable_IVRRenderModels_RenderModelHasComponent;
    GetRenderModelThumbnailURL: FnTable_IVRRenderModels_GetRenderModelThumbnailURL;
    GetRenderModelOriginalPath: FnTable_IVRRenderModels_GetRenderModelOriginalPath;
    GetRenderModelErrorNameFromEnum: FnTable_IVRRenderModels_GetRenderModelErrorNameFromEnum;
  end;
  PIVRRenderModels = ^TIVRRenderModels;

  TIVRNotifications = record
    CreateNotification: FnTable_IVRNotifications_CreateNotification;
    RemoveNotification: FnTable_IVRNotifications_RemoveNotification;
  end;
  PIVRNotifications = ^TIVRNotifications;

  TIVRSettings = record
    GetSettingsErrorNameFromEnum: FnTable_IVRSettings_GetSettingsErrorNameFromEnum;
    SetBool: FnTable_IVRSettings_SetBool;
    SetInt32: FnTable_IVRSettings_SetInt32;
    SetFloat: FnTable_IVRSettings_SetFloat;
    SetString: FnTable_IVRSettings_SetString;
    GetBool: FnTable_IVRSettings_GetBool;
    GetInt32: FnTable_IVRSettings_GetInt32;
    GetFloat: FnTable_IVRSettings_GetFloat;
    GetString: FnTable_IVRSettings_GetString;
    RemoveSection: FnTable_IVRSettings_RemoveSection;
    RemoveKeyInSection: FnTable_IVRSettings_RemoveKeyInSection;
  end;
  PIVRSettings = ^TIVRSettings;

  TIVRScreenshots = record
    RequestScreenshot: FnTable_IVRScreenshots_RequestScreenshot;
    HookScreenshot: FnTable_IVRScreenshots_HookScreenshot;
    GetScreenshotPropertyType: FnTable_IVRScreenshots_GetScreenshotPropertyType;
    GetScreenshotPropertyFilename: FnTable_IVRScreenshots_GetScreenshotPropertyFilename;
    UpdateScreenshotProgress: FnTable_IVRScreenshots_UpdateScreenshotProgress;
    TakeStereoScreenshot: FnTable_IVRScreenshots_TakeStereoScreenshot;
    SubmitScreenshot: FnTable_IVRScreenshots_SubmitScreenshot;
  end;
  PIVRScreenshots = ^TIVRScreenshots;

  TIVRResources = record
    LoadSharedResource: FnTable_IVRResources_LoadSharedResource;
    GetResourceFullPath: FnTable_IVRResources_GetResourceFullPath;
  end;
  PIVRResources = ^TIVRResources;

  TIVRDriverManager = record
    GetDriverCount: FnTable_IVRDriverManager_GetDriverCount;
    GetDriverName: FnTable_IVRDriverManager_GetDriverName;
    GetDriverHandle: FnTable_IVRDriverManager_GetDriverHandle;
    IsEnabled: FnTable_IVRDriverManager_IsEnabled;
  end;
  PIVRDriverManager = ^TIVRDriverManager;

  TIVRInput = record
    SetActionManifestPath: FnTable_IVRInput_SetActionManifestPath;
    GetActionSetHandle: FnTable_IVRInput_GetActionSetHandle;
    GetActionHandle: FnTable_IVRInput_GetActionHandle;
    GetInputSourceHandle: FnTable_IVRInput_GetInputSourceHandle;
    UpdateActionState: FnTable_IVRInput_UpdateActionState;
    GetDigitalActionData: FnTable_IVRInput_GetDigitalActionData;
    GetAnalogActionData: FnTable_IVRInput_GetAnalogActionData;
    GetPoseActionDataRelativeToNow: FnTable_IVRInput_GetPoseActionDataRelativeToNow;
    GetPoseActionDataForNextFrame: FnTable_IVRInput_GetPoseActionDataForNextFrame;
    GetSkeletalActionData: FnTable_IVRInput_GetSkeletalActionData;
    GetDominantHand: FnTable_IVRInput_GetDominantHand;
    SetDominantHand: FnTable_IVRInput_SetDominantHand;
    GetBoneCount: FnTable_IVRInput_GetBoneCount;
    GetBoneHierarchy: FnTable_IVRInput_GetBoneHierarchy;
    GetBoneName: FnTable_IVRInput_GetBoneName;
    GetSkeletalReferenceTransforms: FnTable_IVRInput_GetSkeletalReferenceTransforms;
    GetSkeletalTrackingLevel: FnTable_IVRInput_GetSkeletalTrackingLevel;
    GetSkeletalBoneData: FnTable_IVRInput_GetSkeletalBoneData;
    GetSkeletalSummaryData: FnTable_IVRInput_GetSkeletalSummaryData;
    GetSkeletalBoneDataCompressed: FnTable_IVRInput_GetSkeletalBoneDataCompressed;
    DecompressSkeletalBoneData: FnTable_IVRInput_DecompressSkeletalBoneData;
    TriggerHapticVibrationAction: FnTable_IVRInput_TriggerHapticVibrationAction;
    GetActionOrigins: FnTable_IVRInput_GetActionOrigins;
    GetOriginLocalizedName: FnTable_IVRInput_GetOriginLocalizedName;
    GetOriginTrackedDeviceInfo: FnTable_IVRInput_GetOriginTrackedDeviceInfo;
    GetActionBindingInfo: FnTable_IVRInput_GetActionBindingInfo;
    ShowActionOrigins: FnTable_IVRInput_ShowActionOrigins;
    ShowBindingsForActionSet: FnTable_IVRInput_ShowBindingsForActionSet;
    GetComponentStateForBinding: FnTable_IVRInput_GetComponentStateForBinding;
    IsUsingLegacyInput: FnTable_IVRInput_IsUsingLegacyInput;
    OpenBindingUI: FnTable_IVRInput_OpenBindingUI;
    GetBindingVariant: FnTable_IVRInput_GetBindingVariant;
  end;
  PIVRInput = ^TIVRInput;

  TIVRIOBuffer = record
    Open: FnTable_IVRIOBuffer_Open;
    Close: FnTable_IVRIOBuffer_Close;
    Read: FnTable_IVRIOBuffer_Read;
    Write: FnTable_IVRIOBuffer_Write;
    PropertyContainer: FnTable_IVRIOBuffer_PropertyContainer;
    HasReaders: FnTable_IVRIOBuffer_HasReaders;
  end;
  PIVRIOBuffer = ^TIVRIOBuffer;

  TIVRSpatialAnchors = record
    CreateSpatialAnchorFromDescriptor: FnTable_IVRSpatialAnchors_CreateSpatialAnchorFromDescriptor;
    CreateSpatialAnchorFromPose: FnTable_IVRSpatialAnchors_CreateSpatialAnchorFromPose;
    GetSpatialAnchorPose: FnTable_IVRSpatialAnchors_GetSpatialAnchorPose;
    GetSpatialAnchorDescriptor: FnTable_IVRSpatialAnchors_GetSpatialAnchorDescriptor;
  end;
  PIVRSpatialAnchors = ^TIVRSpatialAnchors;

  TIVRDebug = record
    EmitVrProfilerEvent: FnTable_IVRDebug_EmitVrProfilerEvent;
    BeginVrProfilerEvent: FnTable_IVRDebug_BeginVrProfilerEvent;
    FinishVrProfilerEvent: FnTable_IVRDebug_FinishVrProfilerEvent;
    DriverDebugRequest: FnTable_IVRDebug_DriverDebugRequest;
  end;
  PIVRDebug = ^TIVRDebug;

  TIVRProperties = record
    ReadPropertyBatch: FnTable_IVRProperties_ReadPropertyBatch;
    WritePropertyBatch: FnTable_IVRProperties_WritePropertyBatch;
    GetPropErrorNameFromEnum: FnTable_IVRProperties_GetPropErrorNameFromEnum;
    TrackedDeviceToPropertyContainer: FnTable_IVRProperties_TrackedDeviceToPropertyContainer;
  end;
  PIVRProperties = ^TIVRProperties;

  TIVRPaths = record
    ReadPathBatch: FnTable_IVRPaths_ReadPathBatch;
    WritePathBatch: FnTable_IVRPaths_WritePathBatch;
    StringToHandle: FnTable_IVRPaths_StringToHandle;
    HandleToString: FnTable_IVRPaths_HandleToString;
  end;
  PIVRPaths = ^TIVRPaths;

  TIVRBlockQueue = record
    Create: FnTable_IVRBlockQueue_Create;
    Connect: FnTable_IVRBlockQueue_Connect;
    Destroy: FnTable_IVRBlockQueue_Destroy;
    AcquireWriteOnlyBlock: FnTable_IVRBlockQueue_AcquireWriteOnlyBlock;
    ReleaseWriteOnlyBlock: FnTable_IVRBlockQueue_ReleaseWriteOnlyBlock;
    WaitAndAcquireReadOnlyBlock: FnTable_IVRBlockQueue_WaitAndAcquireReadOnlyBlock;
    AcquireReadOnlyBlock: FnTable_IVRBlockQueue_AcquireReadOnlyBlock;
    ReleaseReadOnlyBlock: FnTable_IVRBlockQueue_ReleaseReadOnlyBlock;
    QueueHasReader: FnTable_IVRBlockQueue_QueueHasReader;
  end;
  PIVRBlockQueue = ^TIVRBlockQueue;


var
  IVRSystem: TIVRSystem;
  IVRExtendedDisplay: TIVRExtendedDisplay;
  IVRTrackedCamera: TIVRTrackedCamera;
  IVRApplications: TIVRApplications;
  IVRChaperone: TIVRChaperone;
  IVRChaperoneSetup: TIVRChaperoneSetup;
  IVRCompositor: TIVRCompositor;
  IVROverlay: TIVROverlay;
  IVROverlayView: TIVROverlayView;
  IVRHeadsetView: TIVRHeadsetView;
  IVRRenderModels: TIVRRenderModels;
  IVRNotifications: TIVRNotifications;
  IVRSettings: TIVRSettings;
  IVRScreenshots: TIVRScreenshots;
  IVRResources: TIVRResources;
  IVRDriverManager: TIVRDriverManager;
  IVRInput: TIVRInput;
  IVRIOBuffer: TIVRIOBuffer;
  IVRSpatialAnchors: TIVRSpatialAnchors;
  IVRDebug: TIVRDebug;
  IVRProperties: TIVRProperties;
  IVRPaths: TIVRPaths;
  IVRBlockQueue: TIVRBlockQueue;
  VR_InitInternal: FnTable_VR_InitInternal;
  VR_ShutdownInternal: FnTable_VR_ShutdownInternal;
  VR_IsHmdPresent: FnTable_VR_IsHmdPresent;
  VR_GetGenericInterface: FnTable_VR_GetGenericInterface;
  VR_IsRuntimeInstalled: FnTable_VR_IsRuntimeInstalled;
  VR_GetVRInitErrorAsSymbol: FnTable_VR_GetVRInitErrorAsSymbol;
  VR_GetVRInitErrorAsEnglishDescription: FnTable_VR_GetVRInitErrorAsEnglishDescription;


function OpenVR_Load: Boolean;

implementation

function OpenVR_Load: Boolean;
var
  Lib: TLibHandle = dynlibs.NilHandle;
begin;
  Lib := LoadLibrary(OVRLIB);
  if Lib = dynlibs.NilHandle then Exit(false);

  VR_InitInternal := GetProcedureAddress(Lib, 'VR_InitInternal');
  VR_ShutdownInternal := GetProcedureAddress(Lib, 'VR_ShutdownInternal');
  VR_IsHmdPresent := GetProcedureAddress(Lib, 'VR_IsHmdPresent');
  VR_GetGenericInterface := GetProcedureAddress(Lib, 'VR_GetGenericInterface');
  VR_IsRuntimeInstalled := GetProcedureAddress(Lib, 'VR_IsRuntimeInstalled');
  VR_GetVRInitErrorAsSymbol := GetProcedureAddress(Lib, 'VR_GetVRInitErrorAsSymbol');
  VR_GetVRInitErrorAsEnglishDescription := GetProcedureAddress(Lib, 'VR_GetVRInitErrorAsEnglishDescription');

  Exit(true);
end;

end.