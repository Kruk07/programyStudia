package formularze;

import java.awt.BorderLayout;
import javax.swing.*;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import tabele.Kierownicy;
import tabele.Recepcjonisci;
import tabele.Sprzataczki;

public class UsunPracownik extends JFrame {

	private JPanel contentPane;

	/**
	 * Launch the application.
	 */

	private JTextField ImietextField;
	private JTextField NazwiskotextField;
	private JTextField PESELtextField;
	private JTextField DataZatrudnieniatextField;
	private JTextField PensjatextField;
	private JTextField IDKierownikatextField;
	private JButton btnId;
	/**
	 * Create the frame.
	 */
	public UsunPracownik(final Connection conn) {
		setResizable(false);
		setTitle("Usuñ Pracownika");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 300, 300);
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
		comboBox.setBounds(44, 11, 126, 20);
		contentPane.add(comboBox);
		
		ImietextField = new JTextField();
		ImietextField.setBounds(120, 42, 86, 20);
		contentPane.add(ImietextField);
		ImietextField.setColumns(10);
		
		NazwiskotextField = new JTextField();
		NazwiskotextField.setBounds(120, 73, 86, 20);
		contentPane.add(NazwiskotextField);
		NazwiskotextField.setColumns(10);
		
		PESELtextField = new JTextField();
		PESELtextField.setBounds(120, 104, 86, 20);
		contentPane.add(PESELtextField);
		PESELtextField.setColumns(10);
		
		DataZatrudnieniatextField = new JTextField();
		DataZatrudnieniatextField.setBounds(120, 135, 86, 20);
		contentPane.add(DataZatrudnieniatextField);
		DataZatrudnieniatextField.setColumns(10);
		
		PensjatextField = new JTextField();
		PensjatextField.setBounds(120, 166, 86, 20);
		contentPane.add(PensjatextField);
		PensjatextField.setColumns(10);
		
		IDKierownikatextField = new JTextField();
		IDKierownikatextField.setEnabled(false);
		IDKierownikatextField.setBounds(120, 197, 86, 20);
		contentPane.add(IDKierownikatextField);
		IDKierownikatextField.setColumns(10);
		
		JLabel lblImi = new JLabel("Imi\u0119:");
		lblImi.setHorizontalAlignment(SwingConstants.RIGHT);
		lblImi.setFont(new Font("Tahoma", Font.BOLD, 11));
		lblImi.setBounds(44, 45, 66, 14);
		contentPane.add(lblImi);
		
		JLabel lblNazwisko = new JLabel("Nazwisko:");
		lblNazwisko.setHorizontalAlignment(SwingConstants.RIGHT);
		lblNazwisko.setBounds(44, 76, 66, 14);
		contentPane.add(lblNazwisko);
		
		JLabel lblPesel = new JLabel("Pesel:");
		lblPesel.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPesel.setBounds(44, 107, 66, 14);
		contentPane.add(lblPesel);
		
		JLabel lblDataZatrudnienia = new JLabel("Data Zatrudnienia:");
		lblDataZatrudnienia.setHorizontalAlignment(SwingConstants.RIGHT);
		lblDataZatrudnienia.setBounds(10, 138, 100, 14);
		contentPane.add(lblDataZatrudnienia);
		
		JLabel lblPensja = new JLabel("Pensja:");
		lblPensja.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPensja.setBounds(10, 169, 100, 14);
		contentPane.add(lblPensja);
		
		JLabel lblIdkierownika = new JLabel("IdKierownika:");
		lblIdkierownika.setHorizontalAlignment(SwingConstants.RIGHT);
		lblIdkierownika.setBounds(10, 200, 100, 14);
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
				if (false){
					JOptionPane.showMessageDialog(null, "Niepoprawne dane\nWprowadŸ ponownie");
				}else{
					
					 try{   
					     Statement s = null;
					     ResultSet rs = null;
				  
				  s = conn.createStatement();
				  int peselint=Integer.parseInt(PESEL);
				  double pensjaint=Double.parseDouble(Pensja);
				  if (nazwa.equals("kierownik")){
				         System.out.println("\nUsuwanie rekordu...\n");	

				        s.executeUpdate(
				                 "delete from "+ nazwa+" where "
					                		+ "Imie='"+imie+"' and Nazwisko= '"+nazwisko+"' and PESEL="+PESEL+" and DataZatrudnienia='"+Data+"'and Pensja="+Pensja);
				       // s.executeUpdate(
				         //        "insert into kierownik (Imie,Nazwisko,PESEL,DataZatrudnienia,Pensja) values('Marcin', 'Ca³kowski',123455,'2012-03-03',5000)");
				        
			  
				  }else{
				        s.executeUpdate(
				                 "delete from "+ nazwa+" where "
					                		+ "Imie='"+imie+"' and Nazwisko= '"+nazwisko+"' and PESEL="+PESEL+" and DataZatrudnienia='"+Data+"'and Pensja="+Pensja+" and IDKierownika="+IDKierownika);
				         System.out.println("\nWstawienie rekordu...\n");
				  }

					JOptionPane.showMessageDialog(null, "Usuniêto");
					  
					  


				} catch (SQLException x) {
					// TODO Auto-generated catch block
					JOptionPane.showMessageDialog(null, "Wyst¹pi³ b³¹d podczas dodawania krotki do tabeli\nSprawdŸ poprawnosc danych");

				}
					
					
				}


					
				
				
			}


		});
		btnOk.setBounds(44, 228, 89, 23);
		contentPane.add(btnOk);
		
		JButton btnAnuluj = new JButton("Anuluj");
		btnAnuluj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				dispose();
			}
		});
		btnAnuluj.setBounds(143, 228, 89, 23);
		contentPane.add(btnAnuluj);
		
		btnId = new JButton("Wy\u015Bwietl");
		btnId.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				String nazwa;
				nazwa = comboBox.getSelectedItem().toString();
				if (nazwa.equals("kierownik")){
					Kierownicy framek= new Kierownicy(conn);
					framek.setVisible(true);
				}
				if (nazwa.equals("sprz¹taczka")){
					Sprzataczki framek=new Sprzataczki(conn);
					framek.setVisible(true);
				}
				if (nazwa.equals("recepcjonista")){
					Recepcjonisci framek= new Recepcjonisci(conn);
					framek.setVisible(true);
				}

			}
		});
		btnId.setBounds(180, 10, 104, 23);
		contentPane.add(btnId);
	}
	

}
