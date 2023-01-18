/*
*Projet IGSD 2020-2021
*Auteurs :
* BAAROUN Ahmed
* IMBERT Jessica
*Groupe 3
*/

//Déclarations
PShape gizmo;
Workspace workspace;
Camera camera = new Camera();
Hud hud;
Map3D map;
Land land;
Gpx gpx;

//Fonctions setup et settings pour définir les paramètres d'affichage
void settings() { 
  pixelDensity(displayDensity());
  size(1000, 1000, P3D);
  smooth(8);
  // Setup Head Up Display
  
}

void setup() {
  
  // Display setup
  //fullScreen(P3D);
  //smooth(8);
  frameRate(144);
  
  // Initial drawing
  background(0x40);
  
  // Prepare local coordinate system grid & gizmo
  this.workspace = new Workspace(250*100) ;
  
  // Make camera move easier
  hint(ENABLE_KEY_REPEAT);
  
  // Load Height Map
  this.map = new Map3D("paris_saclay.data");
  this.land = new Land(this.map);
  this.hud = new Hud();
  this.gpx = new Gpx(this.map, "trail.geojson");
}

//Fonction draw pour dessiner les formes demandées
void draw() {
  
  // 3D camera (X+ right / Z+ top / Y+ Front)
  camera(0,2500,1000,0,0,0,0,0,-1);
  
  background(0x40);
  this.workspace.update();
  this.camera.update();
  this.hud.update();
  this.land.update();
  this.gpx.update();

}

//Touches "w" , "haut" , "bas" , "droite" , "gauche" , "+" et "-"
//pour déplacer la caméra, zoomer et montrer/cacher le projet/tracé gpx
void keyPressed() {
  switch (key){
  case 'x':
  case 'X':
    this.gpx.toggle();
  break;
  }
  switch (key) {
  case 'w': 
  case 'W':
    this.workspace.toggle(); 
    this.land.toggle();
    break;
  }
 if (key == CODED) {
   switch (keyCode) {
     case UP:
      //camera.z -= 50 ;
      //camera.y += 0 ;
      camera.adjustColatitude(-PI*50/5000);
   break;
     case DOWN:
      //camera.z += 50 ;
      //camera.y -= 0 ;
      camera.adjustColatitude(PI*50/5000);
   break;
     case LEFT:
      camera.adjustLongitude(-PI*50/5000);
   break;
     case RIGHT:
      camera.adjustLongitude(PI*50/5000);
   break;
    }
  } else {
    switch (key) {
    case '+': 
      camera.adjustRadius(-50);
      break;
    case '-': 
      camera.adjustRadius(50);
      break;
    }
  }
}

//Déplacement de camera avec la souris
void mouseDragged() {
 if (mouseButton == CENTER) {
  //Camera Horizontale
  float dx = mouseX - pmouseX;
  camera.adjustLongitude(-PI*50/5000);
  //Camera Verticale
  float dy = mouseY - pmouseY;
  camera.adjustLongitude(PI*50/5000);
 }
}
