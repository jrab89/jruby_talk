public class Circle {
  private final int radius;

  public Circle(int radius){
    this.radius = radius;
  }

  public int getRadius(){
    return this.radius;
  }

  public double getArea(){
    return Math.PI * Math.pow(radius, 2);
  }

  public static void main(String[] args){
    int radius = Integer.parseInt(args[0]);
    Circle circle = new Circle(radius);
    System.out.println(circle.getArea());
  }
}