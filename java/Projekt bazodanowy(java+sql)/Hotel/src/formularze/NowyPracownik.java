package formularze;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import tabele.Kierownicy;

import javax.swing.JComboBox;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;

public class NowyPracownik extends JFrame {

	private JPanel contentPane;
	private JTextField ImietextField;
	private JTextField NazwiskotextField;
	private JTextField PESELtextField;
	private JTextField DataZatrudnieniatextField;
	private JTextField PensjatextField;
	private JTextField IDKierownikatextField;
	private JButton btnId;

	/**
	 * Launch the application.
	 */

	/**
	 * Create the frame.
	 */
	public NowyPracownik(final Connection conn) {
		setResizable(false);
		setTitle("Dodaj Pracownika");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 320, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		final JComboBox comboBox = new JComboBox();
		comboBox.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String nazwa;
				nazwa = comboBox.getSelectedItem().toString();
				if (nazwa.equals("kierownik")){
					IDKierownikatextField.setEnabled(false);
					btnId.setEnabled(false);
				} else{
					IDKierownikatextField.setEnabled(true);	
					btnId.setEnabled(true);
				}
			}
		});
		comboBox.setModel(new DefaultComboBoxModel(new String[] {"kierownik", "recepcjonista", "sprz\u0105taczka"}));
		comboBox.setBounds(100, 11, 126, 20);
		contentPane.add(comboBox);
		
		ImietextField = new JTextField();
		ImietextField.setBounds(140, 42, 86, 20);
		contentPane.add(ImietextField);
		ImietextField.setColumns(10);
		
		NazwiskotextField = new JTextField();
		NazwiskotextField.setBounds(140, 73, 86, 20);
		contentPane.add(NazwiskotextField);
		NazwiskotextField.setColumns(10);
		
		PESELtextField = new JTextField();
		PESELtextField.setBounds(140, 104, 86, 20);
		contentPane.add(PESELtextField);
		PESELtextField.setColumns(10);
		
		DataZatrudnieniatextField = new JTextField();
		DataZatrudnieniatextField.setBounds(140, 135, 86, 20);
		contentPane.add(DataZatrudnieniatextField);
		DataZatrudnieniatextField.setColumns(10);
		
		PensjatextField = new JTextField();
		PensjatextField.setBounds(140, 166, 86, 20);
		contentPane.add(PensjatextField);
		PensjatextField.setColumns(10);
		
		IDKierownikatextField = new JTextField();
		IDKierownikatextField.setEnabled(false);
		IDKierownikatextField.setBounds(140, 197, 86, 20);
		contentPane.add(IDKierownikatextField);
		IDKierownikatextField.setColumns(10);
		
		JLabel lblImi = new JLabel("Imi\u0119:");
		lblImi.setHorizontalAlignment(SwingConstants.RIGHT);
		lblImi.setFont(new Font("Tahoma", Font.BOLD, 11));
		lblImi.setBounds(64, 45, 66, 14);
		contentPane.add(lblImi);
		
		JLabel lblNazwisko = new JLabel("Nazwisko:");
		lblNazwisko.setHorizontalAlignment(SwingConstants.RIGHT);
		lblNazwisko.setBounds(64, 76, 66, 14);
		contentPane.add(lblNazwisko);
		
		JLabel lblPesel = new JLabel("Pesel:");
		lblPesel.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPesel.setBounds(64, 107, 66, 14);
		contentPane.add(lblPesel);
		
		JLabel lblDataZatrudnienia = new JLabel("Data Zatrudnienia:");
		lblDataZatrudnienia.setHorizontalAlignment(SwingConstants.RIGHT);
		lblDataZatrudnienia.setBounds(10, 138, 120, 14);
		contentPane.add(lblDataZatrudnienia);
		
		JLabel lblPensja = new JLabel("Pensja:");
		lblPensja.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPensja.setBounds(54, 169, 76, 14);
		contentPane.add(lblPensja);
		
		JLabel lblIdkierownika = new JLabel("IdKierownika:");
		lblIdkierownika.setHorizontalAlignment(SwingConstants.RIGHT);
		lblIdkierownika.setBounds(30, 200, 100, 14);
		contentPane.add(lblIdkierownika);
		
		JButton btnOk = new JButton("OK");
		btnOk.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				String nazwa = comboBox.getSelectedItem().toString();
				String imie = ImietextField.getText();
				String nazwisko = NazwiskotextField.getText();
				String PESEL = PESELtextField.getText();
				String Data = DataZatrudnieniatextField.getText();
				String Pensja = PensjatextField.getText();
				String IDKierownika= IDKierownikatextField.getText();
				if (sprawdzPoprawnosc(nazwa,imie,nazwisko,PESEL,Data,Pensja,IDKierownika)==false){
					JOptionPane.showMessageDialog(null, "Niepoprawne dane\nWprowadŸ ponownie");
				}else{
					
					 try{   
					     Statement s = null;
					     ResultSet rs = null;
				  
				  s = conn.createStatement();
				  int peselint=Integer.parseInt(PESEL);
				  double pensjaint=Double.parseDouble(Pensja);
				  if (nazwa.equals("kierownik")){
				         System.out.println("\nWstawienie rekordu...\n");	

				        s.executeUpdate(
				                 "insert into "+ nazwa+" (Imie,Nazwisko,PESEL,DataZatrudnienia,Pensja) values"
					                		+ "('"+imie+"', '"+nazwisko+"',"+PESEL+",'"+Data+"',"+Pensja+")");

				  }else{
				       s.executeUpdate(
				                 "insert into "+ nazwa+"(Imie,Nazwisko,PESEL,DataZatrudnienia,Pensja,idkierownika) values"
				                 		+ " 	('"+imie+"','"+ nazwisko +"',("+ PESEL +"),'"+ Data+ "'," +Pensja+","+IDKierownika+")");
				         System.out.println("\nWstawienie rekordu...\n");
				  }

					JOptionPane.showMessageDialog(null, "Dane wprowadzone pomyslnie");
					  
					  


				} catch (SQLException x) {
					// TODO Auto-generated catch block
					JOptionPane.showMessageDialog(null, "Wyst¹pi³ b³¹d podczas dodawania krotki do tabeli\nSprawdŸ poprawnosc danych");

				}
					
					
				}


					
				
				
			}


		});
		btnOk.setBounds(64, 228, 89, 23);
		contentPane.add(btnOk);
		
		JButton btnAnuluj = new JButton("Anuluj");
		btnAnuluj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				dispose();
			}
		});
		btnAnuluj.setBounds(163, 228, 89, 23);
		contentPane.add(btnAnuluj);
		
		btnId = new JButton("ID");
		btnId.setEnabled(false);
		btnId.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				
				Kierownicy framek= new Kierownicy(conn);
				framek.setVisible(true);
			}
		});
		btnId.setBounds(236, 196, 68, 23);
		contentPane.add(btnId);
	}
	
	boolean sprawdzPoprawnosc(String Nazwa, String Imie,String Nazwisko, String PESEL,String Data,String Pensja,String ID) {
		

		try{
			if ((Imie.length()==0)||(Imie.length()>255)){
				return false;
			}
			if ((Nazwisko.length()==0)||(Nazwisko.length()>255)){
				return false;
			}
			if ((PESEL.length()==0)||(PESEL.length()>255)){
				return false;
			}
			if ((Data.length()==0)||(Data.length()>255)){
				return false;
			}
			if ((Pensja.length()==0)||(Pensja.length()>255)){
				return false;
			}
			String Rok=Data.substring(0, 4);
			String Myslnik1=Data.substring(4, 5);
			String Miesi¹c=Data.substring(5, 7);
			String Myslnik2=Data.substring(7, 8);
			String Dzien=Data.substring(8, 10);
			System.out.println(Rok+Myslnik1+Miesi¹c+Myslnik2+Dzien);
			if (Nazwa.equals("kierownik")!=true){
				if ((ID.length()==0)||(ID.length()>255)){
					return false;
				}
			}
			if ((Myslnik1.equals("-")==false)||(Myslnik2.equals("-")==false)||(Data.length()!=10)){
				return false;
			}	
			
			
			int PESELLiczba=Integer.parseInt(PESEL);
			double PensjaLiczba=Double.parseDouble(Pensja);
			int rokint= Integer.parseInt(Rok);
			int miesi¹cint= Integer.parseInt(Miesi¹c);
			int dzienint= Integer.parseInt(Dzien);
			if(rokint<1||miesi¹cint<1||miesi¹cint>12||dzienint>31||dzienint<1){
				return false;
			}
		}
		catch (Exception e){
			return false;
		}
		
		
		
		
		return true;
		
	}
}


