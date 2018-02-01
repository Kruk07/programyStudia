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

import tabele.Rezerwacje;

import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class UsunRezerwacje extends JFrame {

	private JPanel contentPane;
	private JTextField textField;
	private JButton btnOk;
	private JButton btnAnuluj;

	/**
	 * Launch the application.
	 */


	/**
	 * Create the frame.
	 */
	public UsunRezerwacje(final Connection conn) {
		setResizable(false);
		setTitle("Usuñ Rezerwacjê");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 260, 185);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblWprowadIdrezerwacji = new JLabel("Wprowad\u017A IDRezerwacji");
		lblWprowadIdrezerwacji.setBounds(10, 36, 131, 14);
		contentPane.add(lblWprowadIdrezerwacji);
		
		textField = new JTextField();
		textField.setBounds(151, 33, 86, 20);
		contentPane.add(textField);
		textField.setColumns(10);
		
		JButton btnSprawdId = new JButton("Sprawd\u017A ID");
		btnSprawdId.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				Rezerwacje frameRezerwacje= new Rezerwacje(conn);
				frameRezerwacje.setVisible(true);
			}
		});
		btnSprawdId.setBounds(145, 61, 89, 23);
		contentPane.add(btnSprawdId);
		
		btnOk = new JButton("OK");
		btnOk.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int a=JOptionPane.showConfirmDialog(null,
			             "Czy na pewno chcesz usun¹c?", "PotwierdŸ", JOptionPane.YES_NO_CANCEL_OPTION);
				if (a==0){
					wyœlij(conn);
				}
			}


		});
		btnOk.setBounds(10, 112, 89, 23);
		contentPane.add(btnOk);
		
		btnAnuluj = new JButton("Anuluj");
		btnAnuluj.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		btnAnuluj.setBounds(109, 112, 89, 23);
		contentPane.add(btnAnuluj);
		

	}
	private void wyœlij(Connection conn) {

		Statement zx = null;
		int intid = 0;
		try {
			String id=textField.getText();
			intid=Integer.parseInt(id);
		} catch (NumberFormatException e1) {
			// TODO Auto-generated catch block
			JOptionPane.showMessageDialog(null, "Nie wprowadzono liczby");
			e1.printStackTrace();
		}
		ResultSet rs = null;
		try {
			zx= conn.createStatement();
			zx.executeUpdate("DELETE FROM Rezerwacja Where idRezerwacji="+intid);
			JOptionPane.showMessageDialog(null, "Usuniêto pomyœlnie");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			JOptionPane.showMessageDialog(null, "Wyst¹pi³ b³¹d podczas usuwania\nSprawdŸ poprawnosc danych");
			e.printStackTrace();
		}
	}
}
