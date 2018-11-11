###############################################################################
#
# MetarInfo module event handlers
#
###############################################################################

#
# This is the namespace in which all functions and variables below will exist.
# The name must match the configuration variable "NAME" in the
# [ModuleMetarInfo] section in the configuration file. The name may be changed
# but it must be changed in both places.
#
namespace eval MetarInfo {

#
# Check if this module is loaded in the current logic core
#
if {![info exists CFG_ID]} {
  return;
}

#
# Extract the module name from the current namespace
#
set module_name [namespace tail [namespace current]];


#
# An "overloaded" playMsg that eliminates the need to write the module name
# as the first argument.
#
proc playMsg {msg} {
  variable module_name;
  ::playMsg $module_name $msg;
}


#
# A convenience function for printing out information prefixed by the
# module name
#
proc printInfo {msg} {
  variable module_name;
  puts "$module_name: $msg";
}


#
# Executed when this module is being activated
#
proc activating_module {} {
  variable module_name;
  Module::activating_module $module_name;
}


#
# Executed when this module is being deactivated.
#
proc deactivating_module {} {
  variable module_name;
  Module::deactivating_module $module_name;
}


#
# Executed when the inactivity timeout for this module has expired.
#
proc timeout {} {
  variable module_name;
  Module::timeout $module_name;
}


#
# Executed when playing of the help message for this module has been requested.
#
proc play_help {} {
  variable module_name;
  Module::play_help $module_name;
}


#
# Executed when the state of this module should be reported on the radio
# channel. Typically this is done when a manual identification has been
# triggered by the user by sending a "*".
# This function will only be called if this module is active.
#
proc status_report {} {
  printInfo "status_report called...";
}


# temperature
proc temperature {temp} {
  playMsg "temperature";
  playSilence 100;
  if {$temp == "not"} {
    playMsg "not";
    playMsg "reported";
  } else {
    if { int($temp) < 0} {
       playMsg "minus";
       set temp [string trimleft $temp "-"];
    }
    playNumber $temp;
    if {int($temp) == 1} {
      playMsg "unit_degree";
    } else {
      playMsg "unit_degrees";
    }
    playSilence 100;
  }
  playSilence 200;
}


# dewpoint
proc dewpoint {dewpt} {
  playMsg "dewpoint";
  playSilence 100;
  if {$dewpt == "not"} {
    playMsg "not";
    playMsg "reported";
  } else {
    if { int($dewpt) < 0} {
       playMsg "minus";
       set dewpt [string trimleft $dewpt "-"];
    }
    playNumber $dewpt;
    if {int($dewpt) == 1} {
      playMsg "unit_degree";
    } else {
      playMsg "unit_degrees";
    }
    playSilence 100;
  }
  playSilence 200;
}


# sea level pressure
proc slp {slp} {
  playMsg "slp";
  playNumber $slp;
  playMsg "unit_hPa";
  playSilence 200;
}


# QNH
proc qnh {value} {
  playMsg "qnh";
  if {$value == 1000} {
     playNumber 1;
     playMsg "thousand";
  } else {
     spellNumber $value;
  }
  playMsg "unit_hPa";
  playSilence 200;
}

# output
proc say args {
  variable tsay;

  playSilence 100;
  foreach item $args {
    if [regexp {^(\d+)} $item] {
      sayNumber $item;
    } else {
      if {$item == "."} {
        playMsg "decimal";
      } else {
        playMsg $item;
      }
    }
    playSilence 100;
  }
  playSilence 200;
}

#
# Spell the specified number
#
proc playNr {number} {
  for {set i 0} {$i < [string length $number]} {set i [expr $i + 1]} {
    set ch [string index $number $i];
    if {$ch == "."} {
      playMsg "decimal";
    } else {
      playMsg "$ch";
    }
  }
}


# end of namespace
}

#