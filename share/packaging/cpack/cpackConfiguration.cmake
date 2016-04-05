set(ARTK_HOME ${PROJECT_SOURCE_DIR}/../../../../..)

set(BUILD_ARTEFACTS_PREFIX lib)

###General configuration

##Fill the package control file with the needed information
#Package control file is required and has some important fields that need to be filled.
SET(CPACK_PACKAGE_VENDOR "ARToolKit.org")
SET(CPACK_PACKAGE_CONTACT "info@artoolkit.org")
set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})


##Set the ARToolKit SDK version into the controll file
#Fetch the ARToolKit SDK version from the config.h.in file and set it to the corresponding variables
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MAJOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MAJOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MINOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MINOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_TINY[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE PATCH_VERSION)

string(STRIP "${MAJOR_VERSION}" MAJOR_VERSION)
string(STRIP "${MINOR_VERSION}" MINOR_VERSION)
string(STRIP "${PATCH_VERSION}" PATCH_VERSION)

set(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION}")
set(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION}")
set(CPACK_PACKAGE_VERSION_PATCH "${PATCH_VERSION}")
set(CPACK_PACKAGE_VERSION "${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}")

message(STATUS "Version: " "${MAJOR_VERSION}" "." "${MINOR_VERSION}" "." "${PATCH_VERSION}")
##End Ser ARToolKit SDK version in controll file


###End configuration

#Copy ChangeLog.txt to ${PROJECT_BINARY_DIR} because we need to gzip it later and gzip command does not work with relative paths
file(COPY ${ARTK_HOME}/ChangeLog.txt DESTINATION ${PROJECT_BINARY_DIR})

#Architecture and package file name
if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  set(CPACK_DEBIAN_ARCHITECTURE "amd64")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
  set(BUILD_ARTEFACTS_DIR /opt/jenkins/artoolkitBuildArtifacts/64bit/)
  set(LIB_POSTFIX "64")
else()
  set(CPACK_DEBIAN_ARCHITECTURE "i386")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "i686")
  set(BUILD_ARTEFACTS_DIR /opt/jenkins/artoolkitBuildArtifacts/32bit/)
  set(LIB_POSTFIX "")
endif()

if(${CPACK_GENERATOR} STREQUAL "DEB")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_DEBIAN_ARCHITECTURE})
  #Set DEB package file name. Needs to be ProjectName_MajorVersion.MinorVersion.PatchVersion_CpuArchitecture
  set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}_${ARTKSDK_PACKAGE_ARCH_SUFFIX}")
elseif(${CPACK_GENERATOR} STREQUAL "RPM")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_RPM_PACKAGE_ARCHITECTURE})
  #The '-1' is the package release version number. As we number ARToolKit on its own I don't see a reason for making this number configurable.
  set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-1.${CPACK_RPM_PACKAGE_ARCHITECTURE}")
else()
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CMAKE_SYSTEM_PROCESSOR})
endif()

message(STATUS ${ARTKSDK_PACKAGE_ARCH_SUFFIX})
