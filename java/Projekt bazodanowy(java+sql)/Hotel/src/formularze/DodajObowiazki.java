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

import tabele.Pokoje;
import tabele.Sprzataczki;

import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class DodajObowiazki extends JFrame {

	private JPanel contentPane;
	private JTextField textField;
	private JTextField textField_1;

	/**
	 * Launch the application.
	 */

	/**
	 * Create the frame.
	 */
	public DodajObowiazki(final Connection conn) {
		setTitle("Modyfikuj obowi¹zki");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 343, 167);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblIdpokoju = new JLabel("IDPokoju");
		lblIdpokoju.setBounds(10, 11, 86, 14);
		contentPane.add(lblIdpokoju);
		
		textField = new JTextField();
		textField.setBounds(106, 8, 86, 20);
		contentPane.add(textField);
		textField.setColumns(10);
		
		JLabel lblIdsprztaczki = new JLabel("IDSprz\u0105taczki");
		lblIdsprztaczki.setBounds(10, 36, 86, 14);
		contentPane.add(lblIdsprztaczki);
		
		textField_1 = new JTextField();
		textField_1.setBounds(106, 33, 86, 20);
		contentPane.add(textField_1);
		textField_1.setColumns(10);
		
		JButton btnOk = new JButton("OK");
		btnOk.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modyfikuj(conn);
			}


		});
		btnOk.setBounds(7, 94, 89, 23);
		contentPane.add(btnOk);
		
		JButton btnAnuluj = new JButton("Anuluj");
		btnAnuluj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		btnAnuluj.setBounds(106, 94, 89, 23);
		contentPane.add(btnAnuluj);
		
		JButton btnId = new JButton("ID");
		btnId.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Pokoje framepokojx= new Pokoje(conn);
				framepokojx.setVisible(true);
			}
		});
		btnId.setBounds(202, 7, 89, 23);
		contentPane.add(btnId);
		
		JButton btnId_1 = new JButton("ID");
		btnId_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Sprzataczki framesprz¹taczki= new Sprzataczki(conn);
				framesprz¹taczki.setVisible(true);
				
			}
		});
		btnId_1.setBounds(202, 32, 89, 23);
		contentPane.add(btnId_1);
	}
	private void modyfikuj(Connection conn) {
		// TODO Auto-generated method stub
		String idpokoju=textField.getText();
		String idsprz¹taczki=textField_1.getText();
		int intidpokoju = 0;
		int intidsprz¹taczki = 0;
		try {
			intidpokoju=Integer.parseInt(idpokoju);
			intidsprz¹taczki=Integer.parseInt(idsprz¹taczki);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Statement rs;
		ResultSet xd;
		

		try {
			rs= conn.createStatement();
			rs.executeUpdate("Update pokój 	set idsprz¹taczki="+intidsprz¹taczki+" where idpokoju="+intidpokoju);
			JOptionPane.showMessageDialog(null, "Poprawiono");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
