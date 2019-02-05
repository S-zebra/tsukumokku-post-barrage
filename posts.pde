//Tue Feb 5 2019 12:05 - 1:20 AM

import http.requests.*;

GetRequest req;
JSONArray posts;
ArrayList<PostText> postTexts;
PFont font;
final int POSTS_ROWS = 20;
int shownPosts = 0;

color background = 0;
color foreground = 255;

final int SPEED_MIN = 4;
final int SPEED_MAX = 12;

void setup(){
  //size(480, 480);
  fullScreen();
  fill(foreground);
  font = createFont("HiraginoSans-W3", 32, true);
  textFont(font);
  postTexts = new ArrayList<PostText>();
  req = new GetRequest("https://tsukumokku.herokuapp.com/api/v1/posts?limit=200");
  req.send();
  posts = JSONObject.parse(req.getContent()).getJSONArray("result");
  println(posts);
  for(int i = 0; i < POSTS_ROWS; i++, shownPosts++){
    postTexts.add(new PostText(posts.getJSONObject(i), randomPoint()));
  }
}

Point randomPoint(){
  return new Point(width - random(0, 20), random(font.getSize(), height - font.getSize()) + random(-20, 20));
}

void draw(){
  background(background);
  for(PostText pt : postTexts){
    text(pt.text, pt.pos.x, pt.pos.y);
    pt.move();
    if (isOnEnd(pt) && shownPosts < posts.size()){
      pt.setText(posts.getJSONObject(shownPosts).getString("text"));
      pt.pos = randomPoint();
      shownPosts++;
    }
  }
}

boolean isOnEnd(PostText pt){
  return pt.pos.x < (pt.text.length() * font.getSize()) * -1;
}

class PostText{
  private String text;
  Point pos;
  float speed;
  
  PostText(JSONObject obj, Point pos){ 
    setText(obj.getString("text"));
    this.pos = pos;
  }
  
  void setText(String text){
    // Slowest: -3, fastest: -5
    speed = round(map(text.length(), 1, 50, SPEED_MIN, SPEED_MAX)) * -1;
    this.text = text;
  }
  
  void move(){
    pos.x += speed;
  }
}

class Point{
  float x, y;
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
}
