package tabele;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import hotel.Main;

import javax.swing.JLabel;
import java.awt.Font;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JScrollPane;

public class Recepcjonisci extends JFrame {

	private JPanel contentPane;
	private JTable table;



	/**
	 * Create the frame.
	 */
	public Recepcjonisci(Connection conn) {

		setResizable(false);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setTitle("Recepcjoniœci");
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(0, 0, 444, 271);
		contentPane.add(scrollPane);

		table = new JTable();
		table.setModel(new DefaultTableModel(
			new Object[][] {
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
				{null, null, null, null, null, null, null},
			},
			new String[] {
				"IDRecepcjonisty", "Imi\u0119", "Nazwisko", "PESEL", "Data Zatrudnienia", "Pensja", "IDKierownika"
			}
		));
		
		  try{   
			     Statement s = null;
			     ResultSet rs = null;
		  
		  s = conn.createStatement();
					//System.out.println(tabela);
			        rs = s.executeQuery(
			                 "SELECT * FROM recepcjonista ");
			         System.out.println("\nWyci¹ganie wstawionych rekordów z bazy...\n");
			       
			  
			  
				int i=0;
			while(rs.next()) {

				table.setValueAt(rs.getInt(1), i, 0);
				table.setValueAt(rs.getString(2), i, 1);
				table.setValueAt(rs.getString(3), i, 2);
				table.setValueAt(rs.getInt(4), i, 3);
				table.setValueAt(rs.getDate(5), i, 4);
				table.setValueAt(rs.getInt(6), i,5);
				table.setValueAt(rs.getInt(7), i, 6);
		        System.out.println(" " + rs.getInt(1) + " " + rs.getString(2) + " " + rs.getString(3) + " "
		        		+ rs.getInt(4)+ " " + rs.getDate(5)+ " " + rs.getInt(6));	
		        i++;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		scrollPane.setViewportView(table);

		
	
}
}
