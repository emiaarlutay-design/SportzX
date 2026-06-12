"""Generate a minimal but complete Xcode project for SportzX."""
import os
import uuid

SRC = 'SportzX'

def uid():
    return uuid.uuid4().hex.upper()

# Collect all source files
swift_files = []
plist_files = []
for root, dirs, files in os.walk(SRC):
    for f in files:
        path = os.path.join(root, f).replace('\\', '/')
        if f.endswith('.swift'):
            swift_files.append(path)
        elif f == 'Info.plist':
            plist_files.append(path)

# Generate all UUIDs in advance
root_id = uid()
main_group_id = uid()
products_group_id = uid()
src_group_id = uid()
res_group_id = uid()
product_ref_id = uid()
native_target_id = uid()
target_config_list_id = uid()
project_config_list_id = uid()
debug_config_id = uid()
release_config_id = uid()
sources_phase_id = uid()
frameworks_phase_id = uid()
resources_phase_id = uid()

file_refs = {}
build_refs = {}

objects = {}

# MARK: - File References & Build Files
file_ids = []
for sw in swift_files:
    fr = uid()
    br = uid()
    name = os.path.basename(sw)
    objects[fr] = {
        'isa': 'PBXFileReference',
        'lastKnownFileType': 'sourcecode.swift',
        'name': name,
        'path': sw,
        'sourceTree': 'SOURCE_ROOT'
    }
    objects[br] = {
        'isa': 'PBXBuildFile',
        'fileRef': fr
    }
    file_refs[sw] = fr
    build_refs[sw] = br
    file_ids.append(fr)

for pl in plist_files:
    fr = uid()
    name = os.path.basename(pl)
    objects[fr] = {
        'isa': 'PBXFileReference',
        'lastKnownFileType': 'text.plist.xml',
        'name': name,
        'path': pl,
        'sourceTree': 'SOURCE_ROOT'
    }
    file_refs[pl] = fr
    file_ids.append(fr)

objects[product_ref_id] = {
    'isa': 'PBXFileReference',
    'explicitFileType': 'wrapper.application',
    'includeInIndex': 0,
    'path': 'SportzX.app',
    'sourceTree': 'BUILT_PRODUCTS_DIR'
}

# MARK: - Groups
objects[main_group_id] = {
    'isa': 'PBXGroup',
    'children': [src_group_id, products_group_id],
    'sourceTree': '<group>'
}

objects[src_group_id] = {
    'isa': 'PBXGroup',
    'children': list(file_refs.values()),
    'name': 'SportzX',
    'path': '',
    'sourceTree': 'SOURCE_ROOT'
}

objects[products_group_id] = {
    'isa': 'PBXGroup',
    'children': [product_ref_id],
    'name': 'Products',
    'sourceTree': '<group>'
}

# MARK: - Build Phases
objects[sources_phase_id] = {
    'isa': 'PBXSourcesBuildPhase',
    'buildActionMask': 2147483647,
    'files': [{'fileRef': build_refs[sw]} for sw in swift_files if sw in build_refs],
    'runOnlyForDeploymentPostprocessing': 0
}

objects[frameworks_phase_id] = {
    'isa': 'PBXFrameworksBuildPhase',
    'buildActionMask': 2147483647,
    'files': [],
    'runOnlyForDeploymentPostprocessing': 0
}

objects[resources_phase_id] = {
    'isa': 'PBXResourcesBuildPhase',
    'buildActionMask': 2147483647,
    'files': [],
    'runOnlyForDeploymentPostprocessing': 0
}

# MARK: - Build Configurations
build_settings = {
    'ASSETCATALOG_COMPILER_APPICON_NAME': 'AppIcon',
    'ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME': 'AccentColor',
    'CODE_SIGN_IDENTITY': '',
    'CODE_SIGNING_ALLOWED': 'NO',
    'CODE_SIGNING_REQUIRED': 'NO',
    'CURRENT_PROJECT_VERSION': '1',
    'ENABLE_PREVIEWS': 'YES',
    'GENERATE_INFOPLIST_FILE': 'YES',
    'INFOPLIST_FILE': 'SportzX/Info.plist',
    'INFOPLIST_KEY_CFBundleDisplayName': 'SportzX',
    'INFOPLIST_KEY_UIApplicationSceneManifest_Generation': 'YES',
    'INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents': 'YES',
    'INFOPLIST_KEY_UILaunchScreen_Generation': 'YES',
    'INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad': [
        'UIInterfaceOrientationPortrait',
        'UIInterfaceOrientationLandscapeLeft',
        'UIInterfaceOrientationLandscapeRight'
    ],
    'INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone': 'UIInterfaceOrientationPortrait',
    'IPHONEOS_DEPLOYMENT_TARGET': '16.0',
    'MARKETING_VERSION': '1.0.0',
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.sportzx.ios',
    'PRODUCT_NAME': 'SportzX',
    'SWIFT_EMIT_LOC_STRINGS': 'YES',
    'SWIFT_VERSION': '5.0',
    'TARGETED_DEVICE_FAMILY': '1'
}

objects[debug_config_id] = {
    'isa': 'XCBuildConfiguration',
    'buildSettings': {**build_settings, 'SWIFT_ACTIVE_COMPILATION_CONDITIONS': 'DEBUG'},
    'name': 'Debug'
}
objects[release_config_id] = {
    'isa': 'XCBuildConfiguration',
    'buildSettings': build_settings,
    'name': 'Release'
}

objects[project_config_list_id] = {
    'isa': 'XCConfigurationList',
    'buildConfigurations': [debug_config_id, release_config_id],
    'defaultConfigurationIsVisible': 0,
    'defaultConfigurationName': 'Release'
}

objects[target_config_list_id] = {
    'isa': 'XCConfigurationList',
    'buildConfigurations': [debug_config_id, release_config_id],
    'defaultConfigurationIsVisible': 0,
    'defaultConfigurationName': 'Release'
}

# MARK: - Native Target
objects[native_target_id] = {
    'isa': 'PBXNativeTarget',
    'buildConfigurationList': target_config_list_id,
    'buildPhases': [sources_phase_id, frameworks_phase_id, resources_phase_id],
    'buildRules': [],
    'dependencies': [],
    'name': 'SportzX',
    'productName': 'SportzX',
    'productReference': product_ref_id,
    'productType': 'com.apple.product-type.application'
}

# MARK: - Root Project
objects[root_id] = {
    'isa': 'PBXProject',
    'attributes': {
        'BuildIndependentTargetsInParallel': 1,
        'LastSwiftUpdateCheck': 1540,
        'LastUpgradeCheck': 1540
    },
    'buildConfigurationList': project_config_list_id,
    'compatibilityVersion': 'Xcode 14.0',
    'developmentRegion': 'en',
    'hasScannedForEncodings': 0,
    'knownRegions': ['en', 'Base'],
    'mainGroup': main_group_id,
    'productRefGroup': products_group_id,
    'projectDirPath': '',
    'projectRoot': '',
    'targets': [native_target_id]
}

# MARK: - Write
pbx = {
    'archiveVersion': 1,
    'classes': {},
    'objectVersion': 60,
    'objects': objects,
    'rootObject': root_id
}

os.makedirs('SportzX.xcodeproj', exist_ok=True)

# plistlib writes in XML format with proper structure
import plistlib
with open('SportzX.xcodeproj/project.pbxproj', 'wb') as f:
    plistlib.dump(pbx, f)

print(f'Generated SportzX.xcodeproj with {len(swift_files)} Swift files and {len(plist_files)} plist files')
print(f'Swift files: {[os.path.basename(s) for s in swift_files]}')

# Verify target build settings have INFOPLIST_FILE
print('Verifying project...')
with open('SportzX.xcodeproj/project.pbxproj', 'rb') as f:
    content = f.read()
if b'INFOPLIST_FILE' in content and b'com.sportzx.ios' in content and b'IPHONEOS_DEPLOYMENT_TARGET' in content:
    print('Project verification: OK')
else:
    print('WARNING: Project verification failed - missing key settings')
