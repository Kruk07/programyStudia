package hotel;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import formularze.NowyPracownik;
import tabele.Sprzataczki;

import javax.swing.JButton;
import java.awt.FlowLayout;
import javax.swing.BoxLayout;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.awt.event.ActionEvent;
import java.awt.GridLayout;
import java.awt.CardLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JLabel;
import javax.swing.SpringLayout;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JList;
import javax.swing.JComboBox;
import javax.swing.JTextPane;
import javax.swing.DefaultComboBoxModel;

public class Frame extends JFrame {

	private JPanel contentPane;
	private JComboBox wybor_tabeli;
	private JButton btnWywietlTabel;
	private JButton btnUsuPracownika;
	private JButton btnDodajObowizki;
	private JButton btnWyloguj;



	/**
	 * Create the frame.
	 */
	public Frame(final String userName,Connection conn) {
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 600, 480);
		setTitle("Hotel "+userName);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(new BoxLayout(contentPane, BoxLayout.X_AXIS));

		JPanel panel = new JPanel();
		contentPane.add(panel);
		panel.setLayout(null);
		
		btnWywietlTabel = new JButton("Wy\u015Bwietl tabel\u0119");
		btnWywietlTabel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String tabela;
				tabela = wybor_tabeli.getSelectedItem().toString();
				Main.wyswietlTabele(tabela);
			}
		});
		btnWywietlTabel.setBounds(435, 126, 139, 23);
		panel.add(btnWywietlTabel);
		
		wybor_tabeli = new JComboBox();
		wybor_tabeli.setModel(new DefaultComboBoxModel(new String[] {"rezerwacja", "klient", "pok\u00F3j", "sprz\u0105taczka", "recepcjonista", "kierownik"}));
		wybor_tabeli.setBounds(435, 95, 139, 18);
		panel.add(wybor_tabeli);
		
		JButton btnDodajPracownika = new JButton("Dodaj pracownika");
		btnDodajPracownika.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				
				Main.wyswietlFormularz();
			}
		});
		btnDodajPracownika.setBounds(435, 160, 139, 23);
		panel.add(btnDodajPracownika);
		
		btnUsuPracownika = new JButton("Usu\u0144 pracownika");
		btnUsuPracownika.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				
				Main.usunPracownika();
			}
		});
		btnUsuPracownika.setBounds(435, 194, 139, 23);
		panel.add(btnUsuPracownika);
		
		JButton btnDodajRezerwacj = new JButton("Dodaj rezerwacj\u0119");
		btnDodajRezerwacj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Main.dodajRezerwacje();
			}
		});
		btnDodajRezerwacj.setBounds(273, 160, 152, 23);
		panel.add(btnDodajRezerwacj);
		
		JButton btnUsuRezerwacj = new JButton("Usu\u0144 rezerwacj\u0119");
		btnUsuRezerwacj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Main.usunRezerwacje();
			}
		});
		btnUsuRezerwacj.setBounds(273, 194, 152, 23);
		panel.add(btnUsuRezerwacj);
		
		btnDodajObowizki = new JButton("Zmie\u0144 obowi\u0105zki");
		btnDodajObowizki.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Main.dodajObowi¹zki();
			}
		});
		btnDodajObowizki.setBounds(435, 228, 139, 23);
		panel.add(btnDodajObowizki);
		
		JButton btnWywietlObowizki = new JButton("Wy\u015Bwietl Obowi\u0105zki");
		btnWywietlObowizki.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Main.wyswietlObowi¹zki(userName);
			}
		});
		btnWywietlObowizki.setBounds(273, 126, 152, 23);
		panel.add(btnWywietlObowizki);
		
		btnWyloguj = new JButton("Wyloguj!");
		btnWyloguj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Main.wyloguj(userName);
			}
		});
		btnWyloguj.setBounds(10, 11, 89, 23);
		panel.add(btnWyloguj);
		  try{   
			     Statement s = null;
			     ResultSet rs = null;
		  
		  s = conn.createStatement();
					//System.out.println(tabela);
			        rs = s.executeQuery(
			                 "SELECT * FROM logintab WHERE loginn='"+userName+"'");
			        if(rs.next()){
			        	btnDodajObowizki.setEnabled(false);
			        	btnUsuRezerwacj.setEnabled(false);
			        	btnDodajRezerwacj.setEnabled(false);
			        	btnUsuPracownika.setEnabled(false);
			        	btnDodajPracownika.setEnabled(false);
			        	btnWywietlTabel.setEnabled(false);
			        }else{
			        	btnWywietlObowizki.setEnabled(false);
			        }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
