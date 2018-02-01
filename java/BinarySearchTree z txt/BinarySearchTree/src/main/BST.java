package main;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;

import main.BST.TreeException;

public class BST {
private static Node root = null;      
 
	public class TreeException extends Throwable {
		TreeException() {}
		TreeException(String msg) { super(msg); }
	}


		private class Node {
			int key;
			int size;
			Node left, right, parent = null;
			Node(int key) {
				this.key = key;
			}
		}  
 

		public void insert(int key) {       
			if(root == null){
				root = new Node(key);
				root.size=1;				
			}
			else {
				Node actual = root;
				Node parent = null;
				while(actual != null) {
					parent = actual;
					if (actual.key > key){
						actual.size++;
						actual=actual.left;
					}else{
						actual.size++;
						actual=actual.right;
					}
					//actual = (actual.key > key) ? actual.left : actual.right;                 
				}
				if(parent.key > key) {
					parent.left = new Node(key);
					parent.left.parent = parent;
					parent.left.size=1;
				}
				else {
					parent.right = new Node(key);
					parent.right.parent = parent;
					parent.right.size=1;
				}
			}              
		}              

 



 

		private Node min(Node node) {
			try{
				while(node.left != null){
					node = node.left;			
				}

				return node;			
			}catch(NullPointerException ex){
				return null;
			}

		}

 

		private Node max(Node node) {
			try{
				while(node.right != null){
					node = node.right;			
				}
				return node;			
			}catch(NullPointerException ex){
				return null;
			}
		}

		
		public Node remove(int key) throws TreeException {
			Node node = this.searchDelete(key);
			try{
				Node parent = node.parent;
				Node tmp;
				if(node.left != null && node.right != null) {
					tmp = this.remove(this.successor(key).key);
					tmp.left = node.left;
					if(tmp.left != null){
						tmp.left.parent = tmp;						
					}

					tmp.right = node.right;
					if(tmp.right != null){
						tmp.right.parent = tmp;						
					}

				}
				else{
					if (node.left!=null){
						tmp=node.left;
					}else{

						tmp=node.right;
					}
					//tmp = (node.left != null) ? node.left : node.right;				
				}
				if(tmp != null){
					tmp.parent = parent;				
				}

				if(parent == null){
					root = tmp;				
				}

				else if(parent.left == node){
					parent.left = tmp;				
				}

				else{
					parent.right = tmp;					
				}

				return node;
			}catch(NullPointerException ex){
				return null;
			}

		}


		private Node successor(int key) throws TreeException  {
			Node node = this.search(key);     

			if(node.right != null) {           
				node = node.right;
				while(node.left != null)
					node = node.left;
				return node;
			}

			else if(node.right == null && node != root && node != this.max(root)) {
				Node parent = node.parent;
				while(parent != root && parent.key < node.key)
					parent = parent.parent;
				return parent;
			} else
					throw new TreeException("Not Found Successor");
			}


		public void inOrder(Node node, PrintWriter zapis) {
			if(node != null) {
				inOrder(node.left,zapis);
				System.out.print(node.key+ " SIZE:"+ node.size+ ", ");
				zapis.print(node.key+ " ");
				inOrder(node.right,zapis);
			}
		}

		public static Node searchDelete(int key) {
			Node actual = root;
			try{
				while(actual.key != key){
					if (actual.key>key){
						actual.size--;
						actual=actual.left;
					}else{
						actual.size--;
						actual=actual.right;
					}
				//actual = (actual.key > key) ? actual.left : actual.right;				
				}				
			}catch(NullPointerException asdasdaf){
				return null;
			}
			/*while(actual != null && actual.key != key){
				actual = (actual.key > key) ? actual.left : actual.right;				
			}*/

			return actual;            
		}
		
		
		

		
		public static void oSSelect(Node node, int i){

			int k;
			if (node.left!=null){
				k= node.left.size+1;			
			}else{
				k=1;
			}
			if(i==k){
				System.out.println("OS-SELECT: "+ node.key);
			}
			if (i<k){
				oSSelect (node.left,i);
			}
			if(i>k){
				oSSelect (node.right,i-k);
			}


		}
		public static Node search(int key) {
			Node actual = root;
			try{
				while(actual.key != key){
				actual = (actual.key > key) ? actual.left : actual.right;				
				}				
			}catch(NullPointerException asdasdaf){
				return null;
			}
			/*while(actual != null && actual.key != key){
				actual = (actual.key > key) ? actual.left : actual.right;				
			}*/

			return actual;            
		}
		
		private static int osRank(int key) {

			Node node=root;

			int r;
			if(node.left!=null){
				r= node.left.size+1;			
			}else{
				r=1;
			}
			Node node2=node;
			try{
				while (node2.key!=key){
					if (node2.key>key){
						r-=node2.left.size;
						node2=node2.left;
					}else{
						//r+=node2.right.size;
						r+=1;
						node2=node2.right;
					}
			

				}
				return r;
			}catch (NullPointerException ex){
				System.out.println("Blad");
				return -1;
			}
			
			/*if (node==null){
				System.out.println("Blad");
				return -1;
			}

			


			Node node2=node;
			while (node2!=root){

				if(node2==node2.parent.right){
					if(node2.parent.left!=null){
						r+=node2.parent.left.size+1;						
					}else{
						r+=1;
					}

				}
				try{
					node2=node2.parent;					
				}catch(NullPointerException exp){
					break;
				}

			}
			return r;*/
		}


		public static void main (String args[]) throws Exception, TreeException{
			BST node= new  BST();

			String filePath="C:/Users/krucz_000/Desktop/Workspace/BinarySearchTree/BST.txt";
			FileReader fileReader = new FileReader(filePath);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
		    PrintWriter zapis = new PrintWriter("wynik.txt");
			String textLine = bufferedReader.readLine();
			int liczba_polecen=Integer.parseInt(textLine);
			do {
				if (textLine.startsWith("insert")){
					int key=Integer.parseInt(textLine.substring(7));
					node.insert(key);
				}
				if (textLine.startsWith("delete")){
					int key=Integer.parseInt(textLine.substring(7));
					node.remove(key);
				}
				if (textLine.startsWith("find")){
					int key=Integer.parseInt(textLine.substring(5));
					Node xd = node.search(key);
					if (xd==null){
						System.out.println(0);
					}else{
						System.out.println(1);
					}
				}
				if (textLine.startsWith("min")){
					Node xd = node.min(root);
					if (xd==null){
						zapis.println("");
						System.out.println("");
					}else{
						zapis.println(xd.key);	
						System.out.println(xd.key);
					}

				}
				if (textLine.startsWith("max")){
					Node xd = node.max(root);	
					//System.out.println(xd.key);
					if (xd==null){
						zapis.println("");		
						System.out.println("");
					}else{
						zapis.println(xd.key);	
						System.out.println(xd.key);
					}
				}
				if (textLine.startsWith("inorder")){
					node.inOrder(root,zapis);		
					System.out.println("");
					zapis.println("");
				}
				textLine = bufferedReader.readLine();

			} while(textLine != null);

			
				oSSelect(root,3);				
						
			//long start=System.currentTimeMillis();
			System.out.println("OS RANK:" + osRank(50));
			//long stop=System.currentTimeMillis();
			//System.out.println("Czas wykonania:"+(stop-start));

			 bufferedReader.close();
			 zapis.close();
			
		}








}