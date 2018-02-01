package main;

import java.awt.BasicStroke;
import java.awt.Color;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.XYDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.ui.ApplicationFrame;

public class Chart extends ApplicationFrame{


	   public Chart( String applicationTitle, String chartTitle,int []operacje)
	   {
	      super(applicationTitle);
	      JFreeChart xylineChart = ChartFactory.createXYLineChart(
	         chartTitle ,
	         "N" ,
	         "Iloœc" ,
	         createDataset(operacje) ,
	         PlotOrientation.VERTICAL ,
	         true , true , false);
	         
	      ChartPanel chartPanel = new ChartPanel( xylineChart );
	      chartPanel.setPreferredSize( new java.awt.Dimension( 560 , 367 ) );
	      final XYPlot plot = xylineChart.getXYPlot( );
	      XYLineAndShapeRenderer renderer = new XYLineAndShapeRenderer( );
	      renderer.setSeriesPaint( 0 , Color.RED );


	      renderer.setSeriesStroke( 0 , new BasicStroke( 4.0f ) );


	      plot.setRenderer( renderer ); 
	      setContentPane( chartPanel ); 
	   }
	   
	   private XYDataset createDataset(int []operacjetab)
	   {
	      final XYSeries operacje = new XYSeries( "ilosc operacji" );          
	      for(int i=1;i<operacjetab.length;i++){
	    	  operacje.add(i,operacjetab[i]);

	      }
	      operacje.add(0,0);

	      final XYSeriesCollection dataset = new XYSeriesCollection( );          
	      dataset.addSeries( operacje );          
      

	      return dataset;
	   }


}
