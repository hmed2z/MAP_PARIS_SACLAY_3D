/*
*Classe Workspace
*Determine l'espace de travail
*Modélisation des axes X, Y et Z
*Modélisation de la grille du sol
*/

public class Workspace{

  PShape gizmo;
  PShape grid;

  public Workspace(int size){
    
      //Gizmo
      this.gizmo = createShape();
      this.gizmo.beginShape(LINES);
      this.gizmo.noFill();
      this.gizmo.strokeWeight(3.0f);
      
      // Red X
      this.gizmo.stroke(0xAAFF3F7F);
      gizmo.vertex(2500,0,0);
      gizmo.vertex(0,0,0);
      
      // Green Y
      this.gizmo.stroke(0xAA3FFF7F);
      gizmo.vertex(0,2500,0);
      gizmo.vertex(0,0,0);
      
      // Blue Z
      this.gizmo.stroke(0xAA3F7FFF);
      gizmo.vertex(0,0,350);
      gizmo.vertex(0,0,0);
      
      this.gizmo.endShape();
      
      
      // Grid
      this.grid = createShape();
      this.grid.beginShape(QUADS);
      this.grid.noFill();
      this.grid.stroke(0x77836C3D);
      this.grid.strokeWeight(0.5f);
      for(int i = -size/2 ; i < size/2 ; i+=100){
        for(int j = -size/2 ; j < size/2 ; j+=100){
          this.grid.vertex(i, j);
          this.grid.vertex(i+100, j);
          this.grid.vertex(i+100, j+100);
          this.grid.vertex(i, j+100);
          }
        }
        this.grid.endShape();
     }   
             
  
  public void update(){
    shape(this.gizmo);
    shape(this.grid);
  }
    
  /**
  * Toggle Grid & Gizmo visibility.
  *(Visibilité du gizmo)
  */
  void toggle() {
    this.gizmo.setVisible(!this.gizmo.isVisible());
    this.grid.setVisible(!this.grid.isVisible());
  }
  
}
