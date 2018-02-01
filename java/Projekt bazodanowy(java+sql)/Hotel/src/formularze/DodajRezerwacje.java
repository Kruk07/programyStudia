package formularze;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import tabele.Klienci;
import tabele.Pokoje;
import tabele.Recepcjonisci;

import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import javax.swing.JTextPane;
import javax.swing.SwingConstants;

public class DodajRezerwacje extends JFrame {

	private JPanel contentPane;
	private JTextField ImietextField;
	private JTextField NazwiskotextField;
	private JTextField PESELtextField;
	private JTextField AdrestextField;
	private JTextField IDPokojutextField;
	private JTextField IDRecepcjonistytextField;
	private JTextField RokOdKiedytextField;
	private JTextField RokDoKiedytextField;
	private JLabel lblKwota;
	private JTextField MiesiacOdKiedytextField;
	private JTextField DzienOdKiedytextField;
	private JTextField MiesiacDoKiedytextField;
	private JTextField DzienDoKiedytextField;
	private JTextPane IDKlientatextField;

	/**
	 * Launch the application.
	 */

	

	/**
	 * Create the frame.
	 */
	public DodajRezerwacje(final Connection conn) {
		setTitle("Dodaj Rezerwacje");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 600, 400);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblImiKlienta = new JLabel("Imi\u0119 klienta:");
		lblImiKlienta.setHorizontalAlignment(SwingConstants.RIGHT);
		lblImiKlienta.setBounds(23, 36, 91, 14);
		contentPane.add(lblImiKlienta);
		
		JLabel lblNazwiskoKlienta = new JLabel("Nazwisko klienta:");
		lblNazwiskoKlienta.setHorizontalAlignment(SwingConstants.RIGHT);
		lblNazwiskoKlienta.setBounds(10, 61, 104, 14);
		contentPane.add(lblNazwiskoKlienta);
		
		JLabel lblPesel = new JLabel("PESEL");
		lblPesel.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPesel.setBounds(23, 86, 91, 14);
		contentPane.add(lblPesel);
		
		JLabel lblAdresKlienta = new JLabel("Adres klienta:");
		lblAdresKlienta.setHorizontalAlignment(SwingConstants.RIGHT);
		lblAdresKlienta.setBounds(23, 111, 91, 14);
		contentPane.add(lblAdresKlienta);
		
		ImietextField = new JTextField();
		ImietextField.setBounds(124, 30, 86, 20);
		contentPane.add(ImietextField);
		ImietextField.setColumns(10);
		
		NazwiskotextField = new JTextField();
		NazwiskotextField.setBounds(124, 55, 86, 20);
		contentPane.add(NazwiskotextField);
		NazwiskotextField.setColumns(10);
		
		PESELtextField = new JTextField();
		PESELtextField.setBounds(124, 80, 86, 20);
		contentPane.add(PESELtextField);
		PESELtextField.setColumns(10);
		
		AdrestextField = new JTextField();
		AdrestextField.setBounds(124, 105, 86, 20);
		contentPane.add(AdrestextField);
		AdrestextField.setColumns(10);
		
		JButton btnAnuluj = new JButton("Anuluj");
		btnAnuluj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		btnAnuluj.setBounds(485, 327, 89, 23);
		contentPane.add(btnAnuluj);
		
		JButton btnOk = new JButton("OK");
		btnOk.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (sprawdzCzyOK()==true){
					wyslijDane(conn);	
				}

			}




		});
		btnOk.setBounds(386, 327, 89, 23);
		contentPane.add(btnOk);
		
		JLabel lblIdpokoju = new JLabel("IDPokoju:");
		lblIdpokoju.setHorizontalAlignment(SwingConstants.RIGHT);
		lblIdpokoju.setBounds(357, 15, 60, 14);
		contentPane.add(lblIdpokoju);
		
		IDPokojutextField = new JTextField();
		IDPokojutextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent arg0) {
				
				obliczKoszt(conn);
			}
		});
		IDPokojutextField.setBounds(427, 12, 86, 20);
		contentPane.add(IDPokojutextField);
		IDPokojutextField.setColumns(10);
		
		JButton btnId = new JButton("ID");
		btnId.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Pokoje framepokoj= new Pokoje(conn);
				framepokoj.setVisible(true);
				
			}
		});
		btnId.setBounds(523, 11, 51, 23);
		contentPane.add(btnId);
		
		JLabel lblIdrecep = new JLabel("IDRecepcjonisty:");
		lblIdrecep.setHorizontalAlignment(SwingConstants.RIGHT);
		lblIdrecep.setBounds(319, 40, 98, 14);
		contentPane.add(lblIdrecep);
		
		IDRecepcjonistytextField = new JTextField();
		IDRecepcjonistytextField.setBounds(427, 37, 86, 20);
		contentPane.add(IDRecepcjonistytextField);
		IDRecepcjonistytextField.setColumns(10);
		
		JButton btnId_1 = new JButton("ID");
		btnId_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				Recepcjonisci framerecepcjonisci=new Recepcjonisci(conn);
				framerecepcjonisci.setVisible(true);
			}
		});
		btnId_1.setBounds(523, 36, 51, 23);
		contentPane.add(btnId_1);
		
		JLabel lblOdKiedy = new JLabel("Od Kiedy:");
		lblOdKiedy.setHorizontalAlignment(SwingConstants.RIGHT);
		lblOdKiedy.setBounds(10, 160, 70, 14);
		contentPane.add(lblOdKiedy);
		
		JLabel lblDoKiedy = new JLabel("Do Kiedy:");
		lblDoKiedy.setHorizontalAlignment(SwingConstants.RIGHT);
		lblDoKiedy.setBounds(10, 185, 70, 14);
		contentPane.add(lblDoKiedy);
		
		JLabel lblKoszt = new JLabel("Koszt:");
		lblKoszt.setHorizontalAlignment(SwingConstants.RIGHT);
		lblKoszt.setBounds(10, 210, 70, 14);
		contentPane.add(lblKoszt);
		
		RokOdKiedytextField = new JTextField();
		RokOdKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent arg0) {
				obliczKoszt(conn);
			}


		});
		RokOdKiedytextField.setBounds(80, 157, 34, 20);
		contentPane.add(RokOdKiedytextField);
		RokOdKiedytextField.setColumns(10);
		
		RokDoKiedytextField = new JTextField();
		RokDoKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent e) {
				
				obliczKoszt(conn);
			}
		});
		RokDoKiedytextField.setBounds(80, 185, 34, 20);
		contentPane.add(RokDoKiedytextField);
		RokDoKiedytextField.setColumns(10);
		
		lblKwota = new JLabel("Kwota");
		lblKwota.setBounds(80, 210, 46, 14);
		contentPane.add(lblKwota);
		
		MiesiacOdKiedytextField = new JTextField();
		MiesiacOdKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent e) {
				obliczKoszt(conn);
			}
		});

		MiesiacOdKiedytextField.setBounds(124, 157, 26, 20);
		contentPane.add(MiesiacOdKiedytextField);
		MiesiacOdKiedytextField.setColumns(10);
		
		DzienOdKiedytextField = new JTextField();
		DzienOdKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent e) {
				obliczKoszt(conn);
			}
		});
		DzienOdKiedytextField.setBounds(160, 157, 26, 20);
		contentPane.add(DzienOdKiedytextField);
		DzienOdKiedytextField.setColumns(10);
		
		MiesiacDoKiedytextField = new JTextField();
		MiesiacDoKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent e) {
				obliczKoszt(conn);
			}
		});
		MiesiacDoKiedytextField.setBounds(124, 185, 26, 20);
		contentPane.add(MiesiacDoKiedytextField);
		MiesiacDoKiedytextField.setColumns(10);
		
		DzienDoKiedytextField = new JTextField();
		DzienDoKiedytextField.addKeyListener(new KeyAdapter() {
			@Override
			public void keyReleased(KeyEvent e) {
				obliczKoszt(conn);
			}
		});
		DzienDoKiedytextField.setBounds(160, 185, 26, 20);
		contentPane.add(DzienDoKiedytextField);
		DzienDoKiedytextField.setColumns(10);
		
		JLabel lblIdklienta = new JLabel("IDKlienta");
		lblIdklienta.setHorizontalAlignment(SwingConstants.RIGHT);
		lblIdklienta.setBounds(23, 11, 91, 14);
		contentPane.add(lblIdklienta);
		
		IDKlientatextField = new JTextPane();
		IDKlientatextField.setBounds(124, 4, 48, 20);
		contentPane.add(IDKlientatextField);
		
		JButton btnWypenij = new JButton("Wype\u0142nij");
		btnWypenij.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				   Statement zx = null;
				   ResultSet rs = null;
				   try {
					zx =conn.createStatement();
					rs = zx.executeQuery(
				                 "SELECT * FROM klient WHERE idklienta="+IDKlientatextField.getText());
			    	  while (rs.next()){  
			    		  	
								   ImietextField.setText(rs.getString(2));
								   NazwiskotextField.setText(rs.getString(3));
								   PESELtextField.setText(Integer.toString(rs.getInt(4)));
								   AdrestextField.setText(rs.getString(5));	
			    	  }	  
				} catch (SQLException e1) {
				
					JOptionPane.showMessageDialog(null, "B³ad bazy danych");
					e1.printStackTrace();
				}

				   
			}
		});
		btnWypenij.setBounds(183, 3, 89, 23);
		contentPane.add(btnWypenij);
		
		JButton btnId_2 = new JButton("ID");
		btnId_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Klienci frameKlient= new Klienci (conn);
				frameKlient.setVisible(true);
			}
		});
		btnId_2.setBounds(285, 3, 46, 23);
		contentPane.add(btnId_2);
		
		

	}
	public boolean sprawdzCzyOK() {
		
		String imie=ImietextField.getText();
		String nazwisko=NazwiskotextField.getText();
		String PESEL=PESELtextField.getText();
		String Adres=AdrestextField.getText();
		String IDPokoju=IDPokojutextField.getText();
		String IDRecepcjonisty=IDRecepcjonistytextField.getText();
		String RokodKiedy=RokOdKiedytextField.getText();
		String MiesiacodKiedy=MiesiacOdKiedytextField.getText();
		String DzienodKiedy=DzienOdKiedytextField.getText();
		String RokdoKiedy=RokDoKiedytextField.getText();
		String MiesiacdoKiedy=MiesiacDoKiedytextField.getText();
		String DziendoKiedy=DzienDoKiedytextField.getText();
		String kwota= lblKwota.getText();

		if (imie.length()==0||imie.length()>255){
			JOptionPane.showMessageDialog(null, "Pole imie musi zostac wype³nione");
			return false;
		}
		if (nazwisko.length()==0||nazwisko.length()>255){
			JOptionPane.showMessageDialog(null, "Pole nazwisko musi zostac wype³nione");
			return false;
		}
		if (PESEL.length()==0||PESEL.length()>255){
			JOptionPane.showMessageDialog(null, "Pole PESEL musi zostac wype³nione");
			return false;
		}
		if (Adres.length()==0||Adres.length()>255){
			JOptionPane.showMessageDialog(null, "Pole Adres musi zostac wype³nione");
			return false;
		}
		if (IDPokoju.length()==0||IDPokoju.length()>255){
			JOptionPane.showMessageDialog(null, "Pole IDPokoju musi zostac wype³nione");
			return false;
		}
		if (IDRecepcjonisty.length()==0||IDRecepcjonisty.length()>255){
			JOptionPane.showMessageDialog(null, "Pole IDRecepcjonisty musi zostac wype³nione");
			return false;
		}
		if ((RokodKiedy.length()==0||RokodKiedy.length()>255)||(MiesiacodKiedy.length()==0||MiesiacodKiedy.length()>255)||(DzienodKiedy.length()==0||DzienodKiedy.length()>255)){
			JOptionPane.showMessageDialog(null, "Pola odKiedy musz¹ zostac wype³nione");
			return false;
		}
		if ((RokdoKiedy.length()==0||RokdoKiedy.length()>255)||(MiesiacdoKiedy.length()==0||MiesiacdoKiedy.length()>255)||(DziendoKiedy.length()==0||DziendoKiedy.length()>255)){
			JOptionPane.showMessageDialog(null, "Pola doKiedy musza zostac wype³nione");
			return false;
		}
		if (kwota.length()==0||kwota.length()>255){
			JOptionPane.showMessageDialog(null, "B³¹d Formularza");
			return false;
		}
		if (Double.parseDouble(kwota)<=0){
			JOptionPane.showMessageDialog(null, "B³¹d, SprawdŸ daty");
			return false;
		}
		if (Integer.parseInt(MiesiacdoKiedy)>12||Integer.parseInt(MiesiacodKiedy)>12||Integer.parseInt(DziendoKiedy)>31||Integer.parseInt(DzienodKiedy)>31){
			JOptionPane.showMessageDialog(null, "B³¹d, SprawdŸ daty");
			return false;
		}
		try {
			double doublekwota=Double.parseDouble(kwota);
			int intIDPokoju=Integer.parseInt(IDPokoju);
			int intIDRecepcjonisty=Integer.parseInt(IDRecepcjonisty);
			int intPESEL=Integer.parseInt(PESEL);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			JOptionPane.showMessageDialog(null, "Niepoprawne dane, wprowadz ponownie");
			return false;
		}
		
		return true;
	}
	
	private void obliczKoszt(Connection conn) {

	      try {
			//SimpleDateFormat  dateFormat = new SimpleDateFormat("yyyy, MM, dd");    
			    Calendar c1 = Calendar.getInstance();
			    Calendar c2 = Calendar.getInstance();    
   
			   String rokOdKiedy=RokOdKiedytextField.getText();
			   String miesiacodKiedy=MiesiacOdKiedytextField.getText();
			   String dzienodKiedy=DzienOdKiedytextField.getText();

			   int introkOdKiedy=Integer.parseInt(rokOdKiedy);
			   int intmiesiacOdKiedy=Integer.parseInt(miesiacodKiedy);
			   int intdzienOdKiedy=Integer.parseInt(dzienodKiedy);
   
			   String rokdoKiedy=RokDoKiedytextField.getText();
			   String miesiacdoKiedy=MiesiacDoKiedytextField.getText();
			   String dziendoKiedy=DzienDoKiedytextField.getText();

			   int introkdoKiedy=Integer.parseInt(rokdoKiedy);
			   int intmiesiacdoKiedy=Integer.parseInt(miesiacdoKiedy);
			   int intdziendoKiedy=Integer.parseInt(dziendoKiedy);
			   c1.set(introkOdKiedy, intmiesiacOdKiedy, intdzienOdKiedy);
			   c2.set(introkdoKiedy,intmiesiacdoKiedy,intdziendoKiedy);

			   int z=diffInDays3(c2.getTime(),c1.getTime());
			    
			   Statement zx = null;
			   ResultSet rs = null;
			   double stawka=0;
			    zx = conn.createStatement();

			    rs = zx.executeQuery(
			                 "SELECT StawkaZaDobê FROM pokój WHERE idpokoju="+IDPokojutextField.getText());
 
		    	  if (Integer.parseInt(IDPokojutextField.getText())>17||Integer.parseInt(IDPokojutextField.getText())<2){
		    		  stawka=0;
		    	  }else{
			    	  while (rs.next()){     		  
							   stawka=rs.getDouble(1);
			    	  }	  
		    	  }
		    	  double wynik =stawka*z;
		    	  lblKwota.setText(Double.toString(wynik));
		} catch (Exception e) {
			
			
			lblKwota.setText("");;
		}
	       
	}
	private static int diffInDays3(Date d1, Date d2)
    {
      return Math.round((d1.getTime() - d2.getTime()) /(1000 * 60 * 60 * 24));
    }
	
	
	private void wyslijDane(Connection conn) {
		String imie=ImietextField.getText();
		String nazwisko=NazwiskotextField.getText();
		String PESEL=PESELtextField.getText();
		String Adres=AdrestextField.getText();
		String IDKlienta=IDKlientatextField.getText();
		String IDPokoju=IDPokojutextField.getText();
		String IDRecepcjonisty=IDRecepcjonistytextField.getText();
		String RokodKiedy=RokOdKiedytextField.getText();
		String MiesiacodKiedy=MiesiacOdKiedytextField.getText();
		String DzienodKiedy=DzienOdKiedytextField.getText();
		String RokdoKiedy=RokDoKiedytextField.getText();
		String MiesiacdoKiedy=MiesiacDoKiedytextField.getText();
		String DziendoKiedy=DzienDoKiedytextField.getText();
		String kwota= lblKwota.getText();

		Statement zx = null;
		Statement cd = null;
		Statement xz =null;
		ResultSet rs = null;
		System.out.println("Tu jestem");
		if (IDKlienta.isEmpty()){
			try {
				xz=conn.createStatement();
				zx= conn.createStatement();
				zx.executeUpdate("insert into klient (Imie,Nazwisko,PESEL,Adres) values"+
						" ('"+imie+"','"+nazwisko+"','"+PESEL+"','"+Adres+"')");
				rs= xz.executeQuery("SELECT * FROM klient where Imie='"+imie+"' and Nazwisko='"+nazwisko+"' and PESEL="+PESEL+" and Adres='"+Adres+"'");
				while (rs.next()){
					IDKlienta=Integer.toString(rs.getInt(1));				
				}

			} catch (SQLException e) {
				
				JOptionPane.showMessageDialog(null, "Wyst¹pi³ b³¹d podczas dodawania klienta\nSprawdŸ poprawnosc danych");
				e.printStackTrace();
			}
		}
		String statuspokoju="";
		try {
			cd=conn.createStatement();
			rs= cd.executeQuery("SELECT * FROM pokój where idPokoju="+IDPokoju);
			while(rs.next()){
				statuspokoju=rs.getString(5);			
			}

		} catch (SQLException e1) {
			
			e1.printStackTrace();
		}
		System.out.println(statuspokoju);
		if (statuspokoju.equals("N")){
			
			String odkiedy=RokodKiedy+"-"+MiesiacodKiedy+"-"+DzienodKiedy;
			String dokiedy=RokdoKiedy+"-"+MiesiacdoKiedy+"-"+DziendoKiedy;
			Statement aaa = null;	

			try {
				aaa =conn.createStatement();
				System.out.println(Double.parseDouble(kwota));
				aaa.executeUpdate("INSERT INTO rezerwacja (idKlienta,idPokoju,idRecepcjonisty,OdKiedy,DoKiedy,Koszt) values"
						+" ("+IDKlienta+","+IDPokoju+","+IDRecepcjonisty+",'"+odkiedy+"','"+dokiedy+"',"+kwota+" )"	);
				JOptionPane.showMessageDialog(null, "Dodano pomyœlnie");
			} catch (SQLException e) {
				
				JOptionPane.showMessageDialog(null, "Wyst¹pi³ b³¹d podczas dodawania rezerwacji\nSprawdŸ poprawnosc danych");
				e.printStackTrace();
			}
		}else{
			JOptionPane.showMessageDialog(null, "Ten pokój jest zajêty\n wybierz inny");
		}
		

	}
}
