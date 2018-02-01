package hotel;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JTextArea;
import javax.swing.JPasswordField;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.CardLayout;
import javax.swing.BoxLayout;
import net.miginfocom.swing.MigLayout;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class Login extends JFrame {

	private JPanel contentPane;
	private JPanel panel;
	private JLabel lblLogin;
	public JTextField txtLogin;
	private JLabel lblHaslo;
	private JButton btnLoginToProgram;
	public JTextField txtHaslo;
	private JPasswordField pwdSsadfa;

//Uøytkownicy:
	/*
	 * TestingUser-admin
	 * KarolinaP-sprzπtaczka
	 * KrystynaN-sprzπtaczka
	 * HAS£O-12345
	 */

	/**
	 * Create the frame.
	 */
	public Login() {
		setTitle("Login");
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 314, 242);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(new BoxLayout(contentPane, BoxLayout.X_AXIS));
		
		panel = new JPanel();
		contentPane.add(panel);
		
		lblLogin = new JLabel("Login:");
		panel.add(lblLogin);
		
		txtLogin = new JTextField();
		txtLogin.setText("Login");
		panel.add(txtLogin);
		txtLogin.setColumns(10);
		
		lblHaslo = new JLabel("Haslo");
		panel.add(lblHaslo);
		
		txtHaslo = new JPasswordField();
		txtHaslo.setText("Haslo");
		panel.add(txtHaslo);
		txtHaslo.setColumns(10);
		
		btnLoginToProgram = new JButton("Login to program!");
		btnLoginToProgram.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				String login=txtLogin.getText();
				String haslo=txtHaslo.getText();
				try{
					Main.zaloguj(login,haslo);					
				}catch(Exception ex){
					System.out.println("B£•D");
					JOptionPane.showMessageDialog(null, "Login bπdü has≥o jest niepoprawne");
				}
				

			}
		});

		panel.add(btnLoginToProgram);
		

	}

}
