/*
*Classe Land
*Modélisation du terrain en reliefs
*Intégration de l'illustration satellite
*/

public class Land {
  
    PShape shadow;
    PShape wireFrame;
    PShape satellite;
    Map3D map;
    
    /**
     * Returns a Land object.
     * Prepares land shadow, wireframe and textured shape
     * @param map Land associated elevation Map3D object 
     * @return Land object
     */
     Land(Map3D map) {
       
       //Détermination des limites du terrain modélisé
       final float tileSize = 25.0f;
       this.map = map;       
       float w = (float)Map3D.width;
       float h = (float)Map3D.height;
       
       //Détermination de l'erreur si pas d'image
       File ressource = dataFile("paris_saclay.jpg");
       if (!ressource.exists() || ressource.isDirectory()) {
       println("ERROR: Land texture file " + "paris_saclay.jpg" + " not found.");
       exitActual();
       }
       
       //Chargement de l'image satellite de Paris Saclay
       PImage uvmap = loadImage("paris_saclay.jpg");
       uvmap.resize(5000,3000);
       
       // Shadow shape
         this.shadow = createShape();
         this.shadow.beginShape(QUADS);
         this.shadow.fill(0x992F2F2F);
         this.shadow.noStroke();
         this.shadow.vertex(-2500, 1500,0);
         this.shadow.vertex(-2500, -1500,0);
         this.shadow.vertex(2500, -1500,0);
         this.shadow.vertex(2500, 1500,0);  
         this.shadow.endShape();
   
    //Satellite shape   
    this.satellite = createShape();
    this.satellite.beginShape(QUADS);
    this.satellite.texture(uvmap);
    this.satellite.noFill();
    this.satellite.noStroke();
    this.satellite.emissive(0xD0);

    //Wireframe shape
    this.wireFrame = createShape();
    this.wireFrame.beginShape(QUADS);
    this.wireFrame.noFill();
    this.wireFrame.stroke(#888888);
    this.wireFrame.strokeWeight(0.5f);

    //Coordonnées u & v pour la texture (image)
    int u = 0;
    for (int i = (int)(-w/(2*tileSize)); i < w/(2*tileSize); i++){
      int v = 0;
      for (int j = (int)(-h/(2*tileSize)); j < h/(2*tileSize); j++){
        Map3D.ObjectPoint bl = this.map.new ObjectPoint(i*tileSize, j*tileSize);
        Map3D.ObjectPoint tl = this.map.new ObjectPoint((i+1)*tileSize, j*tileSize);
        Map3D.ObjectPoint tr = this.map.new ObjectPoint((i+1)*tileSize, (j+1)*tileSize);
        Map3D.ObjectPoint br = this.map.new ObjectPoint(i*tileSize, (j+1)*tileSize);
        
        //Calcul de normales
        PVector nbl = bl.toNormal();
        PVector ntl = tl.toNormal();
        PVector ntr = tr.toNormal();
        PVector nbr = br.toNormal();
        
        //Traçage des reliefs en fils de fer
        this.wireFrame.vertex(bl.x, bl.y, bl.z);
        this.wireFrame.vertex(tl.x, tl.y, tl.z);
        this.wireFrame.vertex(tr.x, tr.y, tr.z);
        this.wireFrame.vertex(br.x, br.y, br.z);
        this.satellite.normal(nbl.x, nbl.y, nbl.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(bl.x, bl.y, bl.z, u, v);
        this.satellite.normal(ntl.x, ntl.y, ntl.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(tl.x, tl.y, tl.z, u+tileSize*uvmap.width/5000, v);
        this.satellite.normal(ntr.x, ntr.y, ntr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(tr.x, tr.y, tr.z, u+tileSize*uvmap.width/5000, v+tileSize*uvmap.height/3000);
        this.satellite.normal(nbr.x, nbr.y, nbr.z);
        this.satellite.attrib("heat", 0.0f, 0.0f);
        this.satellite.vertex(br.x, br.y, br.z, u, v+tileSize*uvmap.height/3000);

        v += tileSize*uvmap.height/3000;
      }
      u += tileSize*uvmap.width/5000;
    }
    this.satellite.endShape();
    this.wireFrame.endShape();
       
       // Shapes initial visibility
       this.shadow.setVisible(true);
       //this.wireFrame.setVisible(false);
       this.wireFrame.setVisible(true);
       this.satellite.setVisible(true);  
     }
     
   public void update(){
     shape(this.shadow);
     shape(this.wireFrame);
     shape(this.satellite);
   }
   
   void toggle() {
     this.shadow.setVisible(!this.shadow.isVisible());
     this.wireFrame.setVisible(!this.wireFrame.isVisible());
     this.satellite.setVisible(!this.satellite.isVisible());
   }
}
