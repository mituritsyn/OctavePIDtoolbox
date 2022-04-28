x = 0:0.1:10;
y = sin (x);
plot (x, y, "ydatasource", "y");
for i = 1 : 100
  pause (0.1);
  y = sin (x + 0.1*i);
  refreshdata ();
endfor