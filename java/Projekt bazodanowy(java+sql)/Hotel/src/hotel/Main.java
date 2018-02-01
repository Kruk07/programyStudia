package hotel;

import java.awt.EventQueue;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import javax.swing.JFrame;

import formularze.DodajObowiazki;
import formularze.DodajRezerwacje;

import formularze.NowyPracownik;
import formularze.UsunPracownik;
import formularze.UsunRezerwacje;
import tabele.Kierownicy;
import tabele.Klienci;
import tabele.Pokoje;
import tabele.Recepcjonisci;
import tabele.Rezerwacje;
import tabele.Sprzataczki;
import tabele.Sprzataczkiview;

public class Main extends Frame {


	public Main(String userName, Connection conn) {
		super(userName, conn);
		// TODO Auto-generated constructor stub
	}
	static Connection conn = null; //session
    static String  url ="jdbc:sqlserver://localhost:1433;databaseName=Hotel2;";
    // static String userName="TestingUser";
   // static String password="12345";
    static Login frame;
    static Frame frameF;
	public static void main(String[] args) {

	    	 //zaloguj();

	     
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frame = new Login();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});

		

	}
	public static void zaloguj( String userName,String password) throws Exception{

	     try
	     {
	         conn = DriverManager.getConnection(url,userName,password);
	         conn.setAutoCommit(true);
	     }
	     catch (SQLException sqle)
	     {
	         printSQLException(sqle);
	         throw new Exception();
	     }
	     System.out.println("ZALOGOWANO");
	     frame.dispose();
		     frameF = new Frame(userName,conn);
		     frameF.setVisible(true); 	 
	}
	public static void wyloguj(String userName) {
		// TODO Auto-generated method stub
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	     frameF.dispose();
	     frame = new Login();
	     frame.setVisible(true); 
		
	}
	
	public static void wyswietlFormularz(){
		NowyPracownik frame2 = new NowyPracownik(conn);
		frame2.setVisible(true);	
	}
	public static void usunPracownika(){
		UsunPracownik frame10=new UsunPracownik(conn);
		frame10.setVisible(true);
	}
	public static void dodajRezerwacje() {
		DodajRezerwacje frame11=new DodajRezerwacje(conn);
		frame11.setVisible(true);
	}
	public static void usunRezerwacje(){
		UsunRezerwacje frame12=new UsunRezerwacje(conn);
		frame12.setVisible(true);
	}
	public static void dodajObowi¹zki() {
		// TODO Auto-generated method stub
		DodajObowiazki frame13=new DodajObowiazki(conn);
		frame13.setVisible(true);
		
	}
	public static void wyswietlTabele(String tabela){
			if (tabela.contains("rezerwacja")){
				Rezerwacje frame7= new Rezerwacje(conn);
				frame7.setVisible(true);

			}
			if (tabela.contains("sprz¹taczka")){
				Sprzataczki frame2 = new Sprzataczki(conn);
				frame2.setVisible(true);				
			}
			if (tabela.contains("recepcjonista")){
				Recepcjonisci frame3= new Recepcjonisci(conn);
				frame3.setVisible(true);
			}
			if (tabela.contains("kierownik")){
				Kierownicy frame4= new Kierownicy(conn);
				frame4.setVisible(true);
			}
			if (tabela.contains("klient")){
				Klienci frame5= new Klienci(conn);
				frame5.setVisible(true);
				
			}
			if (tabela.contains("pokój")){
				Pokoje frame6= new Pokoje(conn);
				frame6.setVisible(true);
			}
			 
	}
	public static void printSQLException(SQLException e)
	 {
	     // Unwraps the entire exception chain to unveil the real cause of the Exception.
	     while (e != null)
	     {
	         System.err.println("\n----- SQLException -----");
	         System.err.println("  SQL State:  " + e.getSQLState());
	         System.err.println("  Error Code: " + e.getErrorCode());
	         System.err.println("  Message:    " + e.getMessage());
	         e = e.getNextException();
	     }
	 }
	public static void wyswietlObowi¹zki(String userName) {
		// TODO Auto-generated method stub
		Sprzataczkiview framexd=new Sprzataczkiview(conn,userName);
		framexd.setVisible(true);
	}




}
