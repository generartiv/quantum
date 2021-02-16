
/*
 *----------------------------------------------------------------------------------------------
 *  _____            _                 _   _                 
 * |  __ \          | |               | | (_)                
 * | |  | | ___  ___| | __ _ _ __ __ _| |_ _  ___  _ __  ___ 
 * | |  | |/ _ \/ __| |/ _` | '__/ _` | __| |/ _ \| '_ \/ __|
 * | |__| |  __/ (__| | (_| | | | (_| | |_| | (_) | | | \__ \
 * |_____/ \___|\___|_|\__,_|_|  \__,_|\__|_|\___/|_| |_|___/
 *                                                         
 * ----------------------------------------------------------------------------------------------*/
int nbParticles;
ParticleSystem particleSystem;

/* --------------------------------------------------------------------------------------------
 *   ____       _               
 *  / ___|  ___| |_ _   _ _ __  
 *  \___ \ / _ \ __| | | | '_ \ 
 *   ___) |  __/ |_| |_| | |_) |
 *  |____/ \___|\__|\__,_| .__/ 
 *                       |_|    
 -----------------------------------------------------------------------------------------------*/


void setup() {
  size(1280, 720, P2D);
  particleSystem = new ParticleSystem();
  for (int i=0; i<nbParticles; i++) {
    Particle particleTmp = new Particle();
    particleTmp.distance = random(width/3);
    particleTmp.taille = random(width/3);
    particleTmp.alpha = random(255);
    particleSystem.particles.add(particleTmp);
  }

  for (int i=0; i<1000; i++) {
    particleSystem.calcul();
  }
}



/* ---------------------------------------------------------------------------------------------------
 *  _                      
 * | |    ___   ___  _ __  
 * | |   / _ \ / _ \| '_ \ 
 * | |__| (_) | (_) | |_) |
 * |_____\___/ \___/| .__/ 
 *                  |_|  
 -----------------------------------------------------------------------------------------------------*/


void draw() {
  background(0);
  particleSystem.run();

  //saveFrame("output/frame-#####.png");
}


/* ---------------------------------------------------------------------------------------------
 *  _____           _   _      _           
 * |  __ \         | | (_)    | |          
 * | |__) |_ _ _ __| |_ _  ___| | ___  ___ 
 * |  ___/ _` | '__| __| |/ __| |/ _ \/ __|
 * | |  | (_| | |  | |_| | (__| |  __/\__ \
 * |_|   \__,_|_|   \__|_|\___|_|\___||___/
 *                                         
 *                            
 -------------------------------------------------------------------------------------------*/

/* --------------------------------------------------------------------------------*\
 
 CLASS PARTICLE SYSTEM 
 
 \* ---------------------------------------------------------------------------------*/

class ParticleSystem {

  Courbe courbe = new Courbe();
  ArrayList<Particle> particles;


  ParticleSystem () {
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    Particle tmpParticle = new Particle();
    particles.add(tmpParticle);
  }

  void run() {

    calcul();
    display();
  }

  void calcul() {

    courbe.calc();
    
    nbParticles = 62;
    if (particles.size()<nbParticles) {
      addParticle();
    }

    for (int i = 0; i < particles.size(); i++) {
      Particle particleActu = particles.get(i);
      if (particleActu.taille<23 && particleActu.alpha<34 && random(1000)>998) {
        courbe.init(particleActu.position.x, particleActu.position.y);
      }
      if (particleActu.alpha>17 && particleActu.position.x<width && particleActu.position.x>=0 && particleActu.position.y<height && particleActu.position.y>=0) {
        particleActu.calcul();
      } else {
        particles.remove(i);
      }
    }
  }

  void display() {
    translate(width/2, height/2);
    rotate(cos(noise(millis()*0.00001)*TWO_PI)*TWO_PI);
    translate(-width/2 - noise(millis()*0.0002745) * 100, -height/2 - noise(millis()*0.0001358) * 100);

    courbe.display();

    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).display();
    }

    if (random(100)>70) {
      strokeWeight(random(10));
      point(random(width), random(height));
    }
  }
}

/* --------------------------------------------------------------------------------*\
 
 CLASS PARTICLE 
 
 \* ---------------------------------------------------------------------------------*/

class Particle {

  PVector position;
  float angle;
  float distance;
  float vDistance;
  float taille;
  float vTaille;
  float alpha;
  float vAlpha;



  Particle() {
    position = new PVector(1, 1);
    angle = random(0, 2*PI);

    distance = random(0.1, 14);
    vDistance =  random(1.0001, 1.008) ;
    taille = random(0.1, 1);

    vTaille = random(1.002, 1.037);
    alpha = random(62, 161);
    vAlpha = random(0.972, 0.999);
  }

  void run() {
    calcul();
    display();
  }

  void calcul() {
    distance *= vDistance;
    taille *= vTaille;
    alpha *= vAlpha;
    position.x = cos(angle) * distance + width/2 + random(2);
    position.y = sin(angle) * distance + height/2+ random(2);
  }

  void display() {

    //fill(255, 255, 255, a);
    noFill();

    //noStroke();


    stroke(255, 255, 255, alpha/2);
    strokeWeight(random(2, 7));
    arc(position.x, position.y, taille, taille, 0, 2*PI);

    stroke(255, 255, 255, alpha-random(10));
    strokeWeight(1);
    arc(position.x+random(-2, 2), position.y+random(-2, 2), taille, taille, 0, 2*PI);
  }
}

/* --------------------------------------------------------------------------------*\
 
 CLASS COURBE
 
 \* ---------------------------------------------------------------------------------*/

class Courbe {
  PGraphics courbe;
  float angle;
  float ajoutAngle;
  float vAngle;
  float alpha;
  PVector position;
  PVector velo;
  Courbe() {
    courbe=createGraphics(width, width);
    init(width/2, height/2);
  }

  void init(float x, float y) {
    alpha = 255;
    angle = random(1, TWO_PI);
    if (random(10)>4) {
      angle = -angle;
    }
    ajoutAngle = random(0.0074, 0.0238);
    if (random(10)>4) {
      ajoutAngle = -ajoutAngle;
    }
    vAngle = random(1.00123, 1.03123);
    velo = new PVector(0, 0);
    position = new PVector(x, y);
    if (random(100)>75) {
      courbe.beginDraw();
      courbe.stroke(255, 255, 255, 156);
      courbe.strokeWeight(2);
      courbe.line(position.x, position.y, cos(angle)* 1280, sin(angle)* 1023);
      courbe.endDraw();
    }
  }


  void calc() {


    alpha*= 0.998;
    ajoutAngle *= vAngle;
    angle += ajoutAngle;

    velo = PVector.fromAngle(angle);
    velo.mult(1.7);
    position.add(velo);

    courbe.beginDraw();
    if (random(100)>96) {
      courbe.fill(0, 0, 0, 82);
      courbe.noStroke();
      courbe.rect(0, 0, width, width);
    }
    courbe.stroke(255, 255, 255, alpha/5);
    courbe.strokeWeight(random(2, 5));
    courbe.point(position.x, position.y);

    courbe.stroke(255, 255, 255, alpha);
    courbe.strokeWeight(1);
    courbe.point(position.x, position.y);

    if (random(100)>90) {
      courbe.strokeWeight(random(4));
      courbe.point(random(width), random(width));
    }

    courbe.endDraw();
  }

  void display() {
    image(courbe, random(2), random(2));
  }
}