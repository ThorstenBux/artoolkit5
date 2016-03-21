set(ARTK_HOME ../../../..)

set(BUILD_ARTEFACTS_PREFIX lib)

###General configuration

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")
  set(CPACK_DEBIAN_ARCHITECTURE "amd64")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
    set(BUILD_ARTEFACTS_DIR /opt/jenkins/artoolkitBuildArtifacts/64bit/)
else()
  set(CPACK_DEBIAN_ARCHITECTURE "i386")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "i686")
    set(BUILD_ARTEFACTS_DIR /opt/jenkins/artoolkitBuildArtifacts/32bit/)
endif()

if(${CPACK_GENERATOR} STREQUAL "DEB")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_DEBIAN_ARCHITECTURE})
elseif(CPACK_GENERATOR STREQUAL "RPM")
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CPACK_RPM_PACKAGE_ARCHITECTURE})
else()
  set(ARTKSDK_PACKAGE_ARCH_SUFFIX ${CMAKE_SYSTEM_PROCESSOR})
endif()

message(STATUS ${ARTKSDK_PACKAGE_ARCH_SUFFIX})


##Fill the package control file with the needed information
#Package control file is required and has some important fields that need to be filled.
SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit runtime")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit.org runtime: \n Contains all necessary libraries for ARToolKit to run.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5")
SET(CPACK_PACKAGE_VENDOR "ARToolKit.org")
SET(CPACK_PACKAGE_CONTACT "info@artoolkit.org")

##Set the ARToolKit SDK version into the controll file
#Fetch the ARToolKit SDK version from the config.h.in file and set it to the corresponding variables
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MAJOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MAJOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_MINOR[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE MINOR_VERSION)
execute_process(COMMAND sed -En -e "s/.*AR_HEADER_VERSION_TINY[[:space:]]+([0-9]*).*/\\1/p" ${ARTK_HOME}/include/AR/config.h.in OUTPUT_VARIABLE PATCH_VERSION)

string(STRIP "${MAJOR_VERSION}" MAJOR_VERSION)
string(STRIP "${MINOR_VERSION}" MINOR_VERSION)
string(STRIP "${PATCH_VERSION}" PATCH_VERSION)

SET(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_PATCH "${PATCH_VERSION}")

message(STATUS "Version: " "${MAJOR_VERSION}" "." "${MINOR_VERSION}" "." "${PATCH_VERSION}")
##End Ser ARToolKit SDK version in controll file

#Set DEB package file name. Needs to be ProjectName_MajorVersion.MinorVersion.PatchVersion_CpuArchitecture
SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}_${ARTKSDK_PACKAGE_ARCH_SUFFIX}")

###End configuration

#Read license file
FILE(STRINGS ${ARTK_HOME}/LICENSE.txt LICENSE_IN NEWLINE_CONSUME)

#Copy ChangeLog.txt to ${PROJECT_BINARY_DIR} because we need to gzip it later and gzip command cannot work with relative paths
file(COPY ${ARTK_HOME}/ChangeLog.txt DESTINATION ${PROJECT_BINARY_DIR})

#Zip changelog file
execute_process(COMMAND gzip -9 -c ${PROJECT_BINARY_DIR}/ChangeLog.txt
                WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
                OUTPUT_FILE "${PROJECT_BINARY_DIR}/changelog.gz")




