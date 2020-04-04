/**
 * __projectname__ is build using NaIDE
 * 
 * @author __authour__
 * @version 1.0
 */
public class __projectname__ extends javax.swing.JFrame {

	/**
     	 * Creates window
    	 */
    	public __projectname__() {
        	initComponents();
    	}
	
	private void initComponents() {
		setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
		javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
		getContentPane().setLayout(layout);
		layout.setHorizontalGroup(
			layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
			.addGap(0, 400, Short.MAX_VALUE)
		);
		layout.setVerticalGroup(
			layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
			.addGap(0, 300, Short.MAX_VALUE)
		);
		pack();
	}

	public static void main(String args[]) {
		/* Set the Nimbus look and feel
		 * If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
	         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
	         */
		try {
			for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
				if ("Nimbus".equals(info.getName())) {
					javax.swing.UIManager.setLookAndFeel(info.getClassName());
					break;
				}
			}
		} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | javax.swing.UnsupportedLookAndFeelException ex) {
			java.util.logging.Logger.getLogger(__projectname__.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
		}
		
		/* Create and display the form */
		java.awt.EventQueue.invokeLater(() -> {
			new __projectname__().setVisible(true);
		});
	}	
}