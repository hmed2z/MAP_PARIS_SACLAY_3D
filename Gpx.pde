/*
*Classe Gpx
*Exemple de tracé GPS
*Point de départ et point d'arrivée
*/

public class Gpx {
  
  //Déclarations
  PShape track;
  PShape posts;
  PShape thumbtacks;
  
  Gpx(Map3D map, String fileName){
    
    //Modélisation du trajet GPS
    this.track = createShape();
    this.track.beginShape(LINE_STRIP);
    this.track.stroke(0xFFEA1AEA);
    this.track.strokeWeight(3.0f);
    Map3D.GeoPoint g;
    Map3D.ObjectPoint o;
    // Check ressources
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
      println("ERROR: GeoJSON file " + fileName + " not found.");
      return;
    }
    // Load geojson and check features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNING: Invalid GeoJSON file.");
       return;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
       println("WARNING: GeoJSON file doesn't contain features collection.");
       return;
    }
      // Parse features
      JSONArray features = geojson.getJSONArray("features");
      if (features == null) {
       println("WARNING: GeoJSON file doesn't contain any feature.");
       return;
      }
      for (int f=0; f<features.size(); f++) {
        JSONObject feature = features.getJSONObject(f);
        if (!feature.hasKey("geometry"))
          break;
          JSONObject geometry = feature.getJSONObject("geometry");
          switch (geometry.getString("type", "undefined")) {
            
          case "LineString":
        
            // GPX Track
            JSONArray coordinates = geometry.getJSONArray("coordinates");
            if (coordinates != null)
              for (int p=0; p < coordinates.size(); p++) {
                JSONArray point = coordinates.getJSONArray(p);
                g = map.new GeoPoint(point.getDouble(0), point.getDouble(1));
                o = map.new ObjectPoint(g);
                this.track.vertex(o.x, o.y, o.z);
              }
            }
       }
       this.track.endShape();
    
     //Traits marquant les étapes du chemin tracé
     this.posts = createShape();
     this.posts.beginShape(LINES);
     this.posts.stroke(0xAA3FFF7F);
     this.posts.strokeWeight(3.0f);
     Map3D.GeoPoint gp;
     Map3D.ObjectPoint op;
  
    for (int f=0; f<features.size(); f++) {
      
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
        JSONObject geometry = feature.getJSONObject("geometry");
        switch (geometry.getString("type", "undefined")) {
        
        case "LineString":
      
          // GPX Track
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null)
            for (int p=0; p < coordinates.size(); p++) {
            JSONArray point = coordinates.getJSONArray(p);
            println("Track ", p, point.getDouble(0), point.getDouble(1));
            }
          break;
          
        case "Point":
      
          // GPX WayPoint
          if (geometry.hasKey("coordinates")) {
            JSONArray point = geometry.getJSONArray("coordinates");
            String description = "Pas d'information.";
            if (feature.hasKey("properties")) {
              description = feature.getJSONObject("properties").getString("desc",
              description);
            }
               gp = map.new GeoPoint(point.getDouble(0), point.getDouble(1));
                    op = map.new ObjectPoint (gp);
                    this.posts.vertex(op.x, op.y, op.z);
                    this.posts.vertex(op.x, op.y, 500);        
          }
        }
    }
    this.posts.endShape();

  
    //Thumbtacks shape (Têtes d'épingles)
    this.thumbtacks = createShape();
    this.thumbtacks.beginShape(POINTS);
    this.thumbtacks.stroke(0xAAEA1AEA);
    this.thumbtacks.strokeWeight(10.0f);
    Map3D.GeoPoint gpa;
    Map3D.ObjectPoint opa;
    
    for (int f=0; f<features.size(); f++) {
      
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
      break;
      JSONObject geometry = feature.getJSONObject("geometry");
      switch (geometry.getString("type", "undefined")) {
        
      case "LineString":
      
        // GPX Track
        JSONArray coordinates = geometry.getJSONArray("coordinates");
        if (coordinates != null)
          for (int p=0; p < coordinates.size(); p++) {
          JSONArray point = coordinates.getJSONArray(p);
          println("Track ", p, point.getDouble(0), point.getDouble(1));
          }
        break;
        
      case "Point":
      
        // GPX WayPoint
        if (geometry.hasKey("coordinates")) {
          JSONArray point = geometry.getJSONArray("coordinates");
          String description = "Pas d'information.";
          if (feature.hasKey("properties")) {
            description = feature.getJSONObject("properties").getString("desc",
            description);
          }
          
          gpa = map.new GeoPoint(point.getDouble(0), point.getDouble(1));
          opa = map.new ObjectPoint (gpa);
          this.thumbtacks.vertex(opa.x, opa.y, 500);
        }
      }    
    }
    this.thumbtacks.endShape();
  
}
  
  //
  public void update(){
    shape(this.track);
    shape(this.posts);
    shape(this.thumbtacks);
  }
  
   //Affichage/Masquage des éléments de la Partie GPX du projet
   public void toggle(){
     this.track.setVisible(!this.track.isVisible());
     this.posts.setVisible(!this.posts.isVisible());
     this.thumbtacks.setVisible(!this.thumbtacks.isVisible());
   }
}
