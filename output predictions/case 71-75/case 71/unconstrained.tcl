file mkdir uncostrained;


# Create ModelBuilder (with two-dimensions and 3 DOF/node)
model basic -ndm 2 -ndf 3

# Create nodes
# ------------

#    tag        X     Y 
  #beam
  node  1      -321      0
  node  2      -311       0
  node  3      -301       0
  node  4      -291       0
  node  5      -280       0
  node  6      -250       0
  node  7      -220       0
  node  8      -190       0
  node  9      -160       0
  node 10      -130       0
  node 11      -100       0
  node 12      -70       0
  node 13      -40        0
  node 14      -30        0
  node 15      -20        0
  node 16      -10        0
  node 17       0        0

# Fix supports
#    tag   DX   DY   RZ
fix   1     0    1    1
#change
fix  17     1    0    1



# Define materials for beams, all units are ksi
# ------------------------------------------
# CONCRETE                  tag   f'c        ec0   f'cu   ecu    lambda(unloading) fcr  Ecr
# Core concrete at beam end(confined)
uniaxialMaterial Concrete01  1  -5.746  -0.0022  -1.149  -0.0171  
# Cover concrete (unconfined)
uniaxialMaterial Concrete01  2  -5.338   -0.002   -1.068   -0.0038 
# beam STEEL
# Reinforcing steel 
set fy 69;      # Yield stress
set E 29000;    # Young's modulus
#                        tag  fy E0    b
uniaxialMaterial Steel01  3  $fy $E    0


# Define cross-section for beams, unit is in.
# ------------------------------------------
set bWidth    34
set bHeight   26

set cover  3
#change
set As_top    5.92;  
set As_bot    12.99;

# some variables derived from the parameters
set y1 [expr $bHeight/2.0]
set z1 [expr $bWidth/2.0]

#beam sections
section Fiber 1 {

    # Create the concrete core fibers
    patch rect 1 10 1 [expr $cover-$y1] [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover]

    # Create the concrete cover fibers
    patch rect 2 10 1 [expr -$y1] [expr $z1-$cover] $y1 $z1
    patch rect 2 10 1  [expr -$y1] [expr -$z1] $y1 [expr $cover-$z1]
    patch rect 2  3 1  [expr -$y1] [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover]
    patch rect 2  3 1  [expr $y1-$cover] [expr $cover-$z1] $y1 [expr $z1-$cover]
    
    # Create the reinforcing fibers
    fiber [expr $y1-$cover] 0 $As_top 3
    fiber [expr $cover-$y1] 0 $As_bot 3
}    


#
# Define beam element
# ----------------------
# Geometry of beam elements
#                tag 
geomTransf Corotational 1

# Number of integration points along length of element
set np 5

# Create the elements using Beam-column elements, stiffness method
#               e            tag ndI ndJ nsecs secID transfTag
set eleType dispBeamColumn

#beam elements 
element $eleType  1   1   2   $np    1       1
element $eleType  2   2   3   $np    1       1
element $eleType  3   3   4   $np    1       1
element $eleType  4   4   5   $np    1       1
element $eleType  5   5   6   $np    1       1
element $eleType  6   6   7   $np    1       1
element $eleType  7   7   8   $np    1       1
element $eleType  8   8   9   $np    1       1
element $eleType  9   9  10   $np    1       1
element $eleType 10  10  11   $np    1       1
element $eleType 11  11  12   $np    1       1
element $eleType 12  12  13   $np    1       1
element $eleType 13  13  14   $np    1       1
element $eleType 14  14  15   $np    1       1
element $eleType 15  15  16   $np    1       1
element $eleType 16  16  17   $np    1       1



#change
#Define recorders
recorder Node -file uncostrained/dEnd.out -time -node 17 -dof 2 disp; 
recorder Node -file uncostrained/axial_f.out -time -node 17 -dof 1 reaction; 
recorder Element -file uncostrained/ele1sect1compreinf.out -time -ele 1 section 1 fiber [expr $y1-$cover] [expr $cover-$z1] stress
recorder Element -file uncostrained/ele1sect1tenreinf.out -time -ele 1 section 1 fiber [expr $cover-$y1] [expr $cover-$z1] stress
recorder Element -file uncostrained/ele1sect_end_compreinf.out -time -ele 16 section 5 fiber [expr $y1-$cover] [expr $cover-$z1] stress
recorder Element -file uncostrained/ele1sect_end_tenreinf.out -time -ele 16 section 5 fiber [expr $cover-$y1] [expr $cover-$z1] stress


# ------------------------------
# Start of analysis generation
# ------------------------------
test NormDispIncr 1.0e-3 1000 3
algorithm KrylovNewton
numberer RCM
constraints Transformation
system ProfileSPD


# Define loading
# --------------------
timeSeries Linear 1
#gravity load
pattern Plain 1 1 {
    #change
    eleLoad -range 1 16 -type -beamUniform -0.0741;
}
integrator LoadControl 0.1
analysis Static
analyze 10;   


loadConst -time 0.0; 

pattern Plain 2 1 {
    #change
    load 17 0 -1 0
}


# ------------------------------
# End of model generation
# ------------------------------


#change
integrator DisplacementControl 17 2 -0.01 
analysis Static


# ------------------------------
# End of analysis generation
# ------------------------------


# ------------------------------
# Finally perform the analysis
# ------------------------------
analyze 4000

