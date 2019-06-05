void read_beat_data()
{
 a = loadTable("timing.csv", "header");
 println("Row "+a.getRowCount()); // 行を数える
 println("Column "+a.getColumnCount()); // 列を数える
 btime = new float[a.getRowCount()];
 btype = new int[a.getRowCount()];
 //save beat data into two array
 for(int i=0;i< a.getRowCount();i++)
 {
 btime[i] = a.getFloat(i, 0);
 btype[i] = a.getInt(i, 1);
 println(i+" "+btime[i]+" "+btype[i]);
 }
}
