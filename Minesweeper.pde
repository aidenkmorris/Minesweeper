boolean[][] tiles = new boolean[10][10];
boolean[][] marked = new boolean[10][10];
boolean [][] flagged = new boolean[10][10];
int[][] colors = {{255, 255, 255}, {0, 0, 200}, {0, 180, 0}, {200, 0 , 0}, {0, 0, 140}, {140, 0, 0}, {0, 160, 140}, {0, 0, 0}, {100, 100, 100}};
boolean gameover;

void setup()
{
  size(800, 800);
  gameSetup();
}

void gameSetup()
{
  for(int i = 0; i < 10; i++)
  {
    for(int j = 0; j < 10; j++)
    {
      marked[i][j] = false;
      flagged[i][j] = false;
    }
  }
  
  textAlign(LEFT);
  gameover = false;
  display();
  generate();
}

void victory()
{
  stroke(0);
  strokeWeight(4);
  fill(220);
  rect(125, 250, 550, 300);
  
  fill(0);
  textSize(60);
  textAlign(CENTER);
  text("Congratulations!", 400, 375);
  text("You win!", 400, 475);
  
  gameover = true;
}

void loss()
{
  gameover = true;
}

void cleanTile(int x, int y)
{
  fill(180);
  stroke(180);
  rect(x * 80 + 15, y * 80 + 15, 55, 55);
}

void drawMine(int x, int y)
{
  //red background
  fill(255, 0, 0);
  stroke(0, 0, 0);
  strokeWeight(2);
  rect(x * 80, y * 80, 80, 80);
  //mine
  fill(0);
  stroke(0);
  strokeWeight(1);
  rect(x * 80 + 35, y * 80 + 10, 10, 20); //top
  rect(x * 80 + 35, y * 80 + 50, 10, 20); //bottom
  rect(x * 80 + 10, y * 80 + 35, 20, 10); //left
  rect(x * 80 + 50, y * 80 + 35, 20, 10); //right
  ellipse(x * 80 + 40, y * 80 + 40, 40, 40); //base
}

void drawTile(int x, int y, int main, int light, int dark) //140, 160, 110
{
  //main tiles
  fill(main);
  stroke(main);
  rect(x * 80, y * 80, 80, 80);
  //light shadows
  fill(light);
  stroke(light);
  rect(x * 80 + 5, y * 80 + 5, 75, 5);
  rect(x * 80 + 5, y * 80 + 5, 5, 75);
  //dark shadows
  fill(dark);
  stroke(dark);
  rect(x * 80 + 5, y * 80 + 75, 75, 5);
  rect(x * 80 + 75, y * 80 + 5, 5, 75);
  
  marked[x][y] = true;
}

void drawFlag(int x, int y)
{
  if(flagged[x][y] == false)
  {
    fill(255, 240, 0);
    stroke(0);
    strokeWeight(2);
    triangle(x * 80 + 17, y * 80 + 67, x * 80 + 42, y * 80 + 17, x * 80 + 67, y * 80 + 67);
    
    fill(0);
    textSize(40);
    text("!", x * 80 + 36, y * 80 + 62);
    
    flagged[x][y] = true;
  }
  else
  {
    cleanTile(x, y);
    flagged[x][y] = false;
  }
}

void leftClick(int x, int y, int origin)
{
  if(marked[x][y] == true)
  {
    return;
  }
  else if(tiles[x][y] == true) //what happens if a mine is clicked
  {
    loss();
    
    for(int i = 0; i < 10; i++)
    {
      for(int j = 0; j < 10; j++)
      {
        if(tiles[i][j] == true)
        {
          drawMine(i, j);
        }
      }
    }
  }
  else //what happens if a safe tile is clicked
  { 
    if(flagged[x][y] == true)
    {
      flagged[x][y] = false;
      cleanTile(x, y);
    }
    
    int n = 0;
    
    if(x != 0)
    {
      if(tiles[x - 1][y] == true) //left
      {
        n++;
      }
    }
    if(x != 0 && y != 0)
    {
      if(tiles[x - 1][y - 1] == true) //up left
      {
        n++;
      }
    }
    if(x != 0 && y != 9)
    {
      if(tiles[x - 1][y + 1] == true) //down left
      {
        n++;
      }
    }
    
    if(x != 9)
    {
      if(tiles[x + 1][y] == true) //right
      {
        n++;
      }
    }
    
    if(y != 0)
    {
      if(tiles[x][y - 1] == true) //up
      {
        n++;
      }
    }
    
    if(y != 9)
    {
      if(tiles[x][y + 1] == true) //down
      {
        n++;
      }
    }
    
    if(x != 9 && y != 0)
    {
      if(tiles[x + 1][y - 1] == true) //up right
      {
        n++;
      }
    }
    
    if(x != 9 && y != 9)
    {
      if(tiles[x + 1][y + 1] == true) //down right
      {
        n++;
      }
    }
    
    fill(colors[n][0], colors[n][1], colors[n][2]);
    textSize(60);
    text(n, x * 80 + 23, y * 80 + 64);
    marked[x][y] = true;
    
    if(n == 0)
    { 
      drawTile(x, y, 140, 160, 110);
        
      if(x != 0 && origin != 4)
      {
        if(marked[x - 1][y] == false)
        {
        leftClick(x - 1, y, 8); //left
        }
      }
      
      if(x != 0 && y != 0 && origin != 5)
      {
        if(marked[x - 1][y- 1] == false)
        {
        leftClick(x - 1, y - 1, 1); //up left
        }
      }
      
      if(x != 0 && y != 9 && origin != 3)
      {
        if(marked[x - 1][y + 1] == false)
        {
        leftClick(x - 1, y + 1, 7); //down left
        }
      }
      
      if(x != 9 && origin != 8)
      {
        if(marked[x + 1][y] == false)
        {
        leftClick(x + 1, y, 4); //right
        }
      }
      
      if(y != 0 && origin != 6)
      {
        if(marked[x][y - 1] == false)
        {
        leftClick(x, y - 1, 2); //up
        }
      }
      
      if(y != 9 && origin != 2)
      {
        if(marked[x][y + 1] == false)
        {
        leftClick(x, y + 1, 6); //down
        }
      }
      
      if(x != 9 && y != 0 && origin != 7)
      {
        if(marked[x + 1][y - 1] == false)
        {
        leftClick(x + 1, y - 1, 3); //up right
        }
      }
      
      if(x != 9 && y != 9 && origin != 1)
      {
        if(marked[x + 1][y + 1] == false)
        {
        leftClick(x + 1, y + 1, 5); //down right
        }
      }
    }
  }
  
  int counter = 0;
  
  for(int i = 0; i < 10; i++)
  {
    for(int j = 0; j < 10; j++)
    {
      if(marked[i][j] == true)
      {
        counter++;
      }
    }
  }
  
  if(counter == 85)
  {
    victory();
  }
}

void rightClick(int x, int y)
{
  if(marked[x][y] == false)
  {
    drawFlag(x, y);
  }
}

void mousePressed()
{
  int x = int(mouseX / 80);
  int y = int(mouseY / 80);
    
  if(gameover == true)
  {
    gameSetup();
  }
  else if(mousePressed && mouseButton == LEFT && flagged[x][y] == false)
  {
    leftClick(x, y, 0);
  }
  else if (mousePressed && mouseButton == RIGHT)
  {
    rightClick(x, y);
  }
}

void generate()
{
  for(int m = 0; m < 10; m++)
  {
    for(int n = 0; n < 10; n++)
    {
      tiles[m][n] = false;
      marked[m][n] = false;
    }
  }
  
  for(int i = 0; i < 15; i++) //generates 15 mines
  {
    int x = int(random(10));
    int y = int(random(10));
    
    if(tiles[x][y] != true) //check to make sure a tile isn't already a bomb
    {
      tiles[x][y] = true;
    }
    else
    {
      i--;
    }
  }
  
  int a = int(random(10));
  int b = int(random(10));
  
  while(tiles[a][b] == true)
  {
    a = int(random(10));
    b = int(random(10));
  }
  
  leftClick(a, b, 0);
}

void display() //draw the board
{
  fill(255);
  stroke(255);
  strokeWeight(1);
  rect(0, 0, 800, 800);
  
  for(int x = 0; x < 10; x++)
  {
    for(int y = 0; y < 10; y++)
    {
      drawTile(x, y, 180, 200, 150);
    }
  }
}

void draw()
{
  //code?
}