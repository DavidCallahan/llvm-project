if ( CMAKE_SYSTEM_NAME MATCHES "Linux|Android|FreeBSD|NetBSD" )
  list(APPEND EXTRA_PLUGINS lldbPluginProcessPOSIX)
endif()

if ( CMAKE_SYSTEM_NAME MATCHES "Windows" )
  list(APPEND EXTRA_PLUGINS lldbPluginProcessWindowsCommon)
endif ()

add_lldb_library(lldbInitialization
  SystemInitializerCommon.cpp
  SystemInitializer.cpp
  SystemLifetimeManager.cpp

  LINK_LIBS
    lldbCore
    lldbHost
    lldbPluginInstructionARM
    lldbPluginInstructionMIPS
    lldbPluginInstructionMIPS64
    lldbPluginProcessGDBRemote
    ${EXTRA_PLUGINS}
    ${LLDB_SYSTEM_LIBS}
  LINK_COMPONENTS
    Support
  )
