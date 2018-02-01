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
import javax.swing.table.DefaultTableModel;
import javax.swing.JScrollPane;
import javax.swing.JTable;

public class Sprzataczkiview extends JFrame {

	private JPanel contentPane;
	private JTable table;



	/**
	 * Create the frame.
	 * @param conn 
	 * @param userName 
	 */
	public Sprzataczkiview(Connection conn, String userName) {
		setTitle("Pokoje przydzielone do pracownika...");
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
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
				{null, null, null, null, null, null},
			},
			new String[] {
				"idPokoju", "TypPokoju", "CzyZarezerwowany", "Imi\u0119", "Nazwisko", "Login"
			}
		) {
			Class[] columnTypes = new Class[] {
				Integer.class, String.class, String.class, String.class, String.class, String.class
			};
			public Class getColumnClass(int columnIndex) {
				return columnTypes[columnIndex];
			}
			boolean[] columnEditables = new boolean[] {
				true, true, true, true, true, false
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
			                 "SELECT * FROM sprzataczki_id WHERE loginn='"+userName+"'");
			         System.out.println("\nWyci¹ganie wstawionych rekordów z bazy...\n");
			       
			  
			  
				int i=0;
			while(rs.next()) {

				table.setValueAt(rs.getInt(1), i, 0);
				table.setValueAt(rs.getString(2), i, 1);
				table.setValueAt(rs.getString(3), i, 2);
				table.setValueAt(rs.getString(4), i, 3);
				table.setValueAt(rs.getString(5), i, 4);
				table.setValueAt(rs.getString(6), i, 5);

		        i++;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		scrollPane.setViewportView(table);

	}

}
