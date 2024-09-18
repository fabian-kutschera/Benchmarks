// Definition of the default mesh discretisation and dip of the fault. 
// The fault here is set to require smaller elements than the volume. 
// This will lead to a statically refined mesh. 
// The mesh discretisation can be changed within Min and Max values using the Gmsh GUI

DefineConstant[ h_domain = {15e3, Min 0, Max 500e3, Name "Mesh spacing within model domain" } ];

// Run these benchmarks using 50 meter resolution on the fault.
DefineConstant[ h_fault = {200.0, Min 0, Max 30e3, Name "Mesh spacing on the fault" } ];
// The value above is also taken for the free surface.

// The fault is a planar thrust fault that dips at an angle of 15 degrees.
DefineConstant[ dip = {15, Min 0, Max 90, Name "Fault dip" } ];

// Specifies the back-end of the CAD engine
SetFactory("OpenCASCADE");

// Length of the fault
l_f = 30e3;
// Depth of the fault, i.e., down-dip width (initially vertically dipping, fault is rotated later)
w_f = 28e3;
// Fault dips towards the north
dip_rad = (180-dip)*Pi/180.;

// Domain size: see sketch (and note different coordinate axis [x,y,z] convention cf. benchmark description [x,z,y])
// Initial tests - see Docker
//X0 = -30e3; //-80e3;
//X1 = -X0;
//Y0 = -15e3; //-70e3;
//Y1 = 53e3; //90e3;
//Z0 = -40e3; //-60e3;
// Final domain size (later filterd with OutputRegionBounds)
X0 = -80e3;
X1 = -X0;
Y0 = -70e3;
Y1 = 90e3;
Z0 = -60e3;

// Create the domain as a box
domain = newv; Box(domain) = {X0, Y0, Z0, X1-X0, Y1-Y0, -Z0};

// Create the fault as a vertically dipping rectangle, centered in x at the hypocenter
fault = news; Rectangle(fault) = {-l_f/2, -w_f, 0, l_f, w_f};

// Rotate the fault, according to its dip
Rotate{ {1, 0, 0}, {0, 0, 0}, dip_rad } { Surface{fault}; }

// Intersect the domain box with the fault rectangle at the free surface
v() = BooleanFragments{ Volume{domain}; Delete; }{ Surface{fault}; Delete; };

// Update all coordinates that define important surfaces within the mesh
eps = 1e-3;
fault_final[] = Surface In BoundingBox{-l_f/2-eps, -w_f-eps, -w_f-eps, l_f/2+eps, w_f+eps, w_f+eps};
top[] = Surface In BoundingBox{X0-eps, Y0-eps, -eps, X1+eps, Y1+eps, eps};
other[] = Surface{:};
other[] -= fault_final[];
other[] -= top[];

// Set mesh spacing of the domain, the fault and the nucleation patch
MeshSize{ PointsOf{Volume{domain};} } = h_domain;
MeshSize{ PointsOf{Surface{fault_final[]};} } = h_fault;
MeshSize{ PointsOf{Surface{top[]};} } = h_fault;

// Define boundary conditions, note the SeisSol specific meaning of 1 = free surface, 3 = dynamic rupture, 5 = absorbing boundary conditions
// free surface
Physical Surface(1) = {top[]};
// dynamic rupture
Physical Surface(3) = {fault_final[]};
// absorbing boundaries
Physical Surface(5) = {other[]};

Physical Volume(1) = {domain};
Mesh.MshFileVersion = 2.2;
