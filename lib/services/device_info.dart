import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceService {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static Map<String, dynamic> _deviceData = <String, dynamic>{};

  static Map<String,dynamic> dispositivo = <String,dynamic>{
  'idDispositivo': '',
  'modelo': '',
  'codigoTipoDispositivo': -1,
  };

  static String plataform = '';

 int mapPlataforma(String plataforma) {
    switch (plataforma) {
      case 'WEB':
        return 1;
      case 'ANDROID':
        return 2;
      case 'IOS':
        return 3;
      case 'LINUX':
        return 5;
      case 'WINDOWS':
        return 4;
      case 'MACOS':
        return 6;
    }
    return 0;
  }

  Future<void> initPlatformState() async {
  var deviceData = <String, dynamic>{};
    try {
      print(deviceData);
      if (kIsWeb) {
        plataform='WEB';
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
        dispositivo['idDispositivo']=deviceData['vendor'];
        dispositivo['modelo']=deviceData['platform'];
      } else {
        if (Platform.isAndroid) {
          plataform='ANDROID';
          deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          dispositivo['idDispositivo']=deviceData['device'];
          dispositivo['modelo']=deviceData['model'];
        } else if (Platform.isIOS) {
          plataform='IOS';
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
          dispositivo['idDispositivo']=deviceData['systemVersion'];
          dispositivo['modelo']=deviceData['model'];
        } else if (Platform.isLinux) {
          plataform='LINUX';
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
          dispositivo['idDispositivo']=deviceData['id'];
          dispositivo['modelo']=deviceData['machineId'];
        } else if (Platform.isMacOS) {
          plataform='MACOS';
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
          dispositivo['idDispositivo']=deviceData['computerName'];
          dispositivo['modelo']=deviceData['model'];
        } else if (Platform.isWindows) {
          plataform='WINDOWS';
          deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
          dispositivo['idDispositivo']=deviceData['computerName'];
          dispositivo['modelo']='PC';
        }
        dispositivo['codigoTipoDispositivo']=mapPlataforma(plataform);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  if (kDebugMode) {
  }
    _deviceData = deviceData;
    print(deviceData);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

}