package tabele;

import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class Pokoje extends JFrame {

	private JPanel contentPane;
	private JTable table;

	/**
	 * Launch the application.
	 */
	/**
	 * Create the frame.
	 */
	public Pokoje(Connection conn) {
		setTitle("Pokoje");
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(new BorderLayout(0, 0));
		setContentPane(contentPane);
		
		JScrollPane scrollPane = new JScrollPane();
		contentPane.add(scrollPane, BorderLayout.CENTER);
		
		table = new JTable();
		table.setModel(new DefaultTableModel(
			new Object[][] {
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, ""},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
			},
			new String[] {
				"IDPokoju", "Typ Pokoju", "Wielkosc Pokoju", "Stawka za dobe", "Czy zarezerwowany", "idSprz\u0105taczki"
			}
		) {
			boolean[] columnEditables = new boolean[] {
				false, false, false, false, false, false
			};
			public boolean isCellEditable(int row, int column) {
				return columnEditables[column];
			}
		});
		
		

		
		try{   
		     Statement s = null;
		     ResultSet rs = null;
	  
	  s = conn.createStatement();
				//System.out.println(tabela);
		        rs = s.executeQuery(
		                 "SELECT * FROM pokój ");
		         System.out.println("\nWyci¹ganie wstawionych rekordów z bazy...\n");
		       
		  
		  
			int i=0;
		while(rs.next()) {

			table.setValueAt(rs.getInt(1), i, 0);
			table.setValueAt(rs.getString(2), i, 1);
			table.setValueAt(rs.getInt(3), i, 2);
			table.setValueAt(rs.getDouble(4), i, 3);
			table.setValueAt(rs.getString(5), i, 4);
			table.setValueAt(rs.getInt(6), i, 5);
	        System.out.println(" " + rs.getInt(1) + " " + rs.getString(2) + " " + rs.getInt(3) + " "
	        		+ rs.getDouble(4)+ " " + rs.getString(5)+ " " + rs.getInt(6));	
	        i++;
		}

	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
		
		
		scrollPane.setViewportView(table);
	}

}
