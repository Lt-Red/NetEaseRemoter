package com.example.neteaseremoter;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Menu;
import android.view.MenuItem;

import java.io.IOException;  
import java.io.OutputStream;
import java.io.PrintStream;  
import java.net.InetSocketAddress;
import java.net.Socket;  
import java.net.SocketTimeoutException;
import android.view.View;  
import android.widget.Button;  
import android.widget.EditText;  
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends ActionBarActivity {

	/* 服务器地址 */  
	  private final String SERVER_HOST_IP = "192.168.1.206";  
	  
	  /* 服务器端口 */  
	  private final int SERVER_HOST_PORT = 30303; 
	    
	  private Button btnConnect;  
	  private Button btnSend;
	  private Button next;
	  private Button privor;
	  private Button up;
	  private Button down;
	  private Button pause;
	  private Button love;
	  
	  private EditText editSend;  
	  private Socket socket;
	  
	  
	  private String CMD_NEXT        	= "124";
	  private String CMD_PVR        	= "123";
	  private String CMD_VOL_UP        	= "126";
	  private String CMD_VOL_DOWN     	= "125";
	  private String CMD_PAUSE        	= "49";
	  private String CMD_LOVE        	= "37";         
	  
	  MyThread scThread;  
	    
	    
	    public Handler myHandler = new Handler() {  
	        @Override  
	        public void handleMessage(Message msg) {  
	            if (msg.what == 0x11) { 
	            	
	            }  
	        }  
	  
	    };   
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		
		initView();  
		  
	    btnConnect.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {  
	    	  String msg = editSend.getText().toString(); 
              //启动线程 向服务器发送和接收信息  
	    	  scThread = new MyThread(msg);
	    	  scThread.start();
	      }  
	    });  
	      
	    btnSend.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  //sendMsg(CMD_NEXT);
	      }  
	    });
	    
	    next.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_NEXT);
	      }  
	    });
	    
	    privor.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_PVR);
	      }  
	    });
	    
	    up.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_VOL_UP);
	      }  
	    });
	    
	    down.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_VOL_DOWN);
	      }  
	    });
	    
	    pause.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_PAUSE);
	      }  
	    });
	    
	    love.setOnClickListener(new Button.OnClickListener()  
	    {  
	      @Override  
	      public void onClick(View v)  
	      {
	    	  sendMsg(CMD_LOVE);
	      }  
	    });
	}

	private void sendMsg(String msg) {
		 try {
			 
			OutputStream ou = socket.getOutputStream();
			//向服务器发送信息  
            ou.write(msg.getBytes("gbk"));  
            ou.flush();
            
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void initView()  
	  {  
	    btnConnect = (Button)findViewById(R.id.btnConnect);  
	    btnSend = (Button)findViewById(R.id.btnSend);  
	    editSend = (EditText)findViewById(R.id.sendMsg);  
	  
	   
	    next = (Button)findViewById(R.id.next);
	    privor = (Button)findViewById(R.id.privor);
	    up = (Button)findViewById(R.id.up);
	    down = (Button)findViewById(R.id.down);
	    pause = (Button)findViewById(R.id.pause);
	    love = (Button)findViewById(R.id.love);
	  }  
	
	
	class MyThread extends Thread {  
		  
        public String ipAddrStr;  
  
        public MyThread(String str) {  
        	ipAddrStr = str;  
        }  
  
        @Override  
        public void run() {  
            //定义消息  
            Message msg = new Message();  
            msg.what = 0x11;  
            Bundle bundle = new Bundle();  
            bundle.clear();  
            try {  
                //连接服务器 并设置连接超时为5秒  
                socket = new Socket();  
                socket.connect(new InetSocketAddress(ipAddrStr, 30303), 5000);             
                  
                msg.setData(bundle);  
                //发送消息 修改UI线程中的组件  
                myHandler.sendMessage(msg);  
              
            } catch (SocketTimeoutException aa) {  
                //连接超时 在UI界面显示消息  
                bundle.putString("msg", "服务器连接失败！请检查网络是否打开");  
                msg.setData(bundle);  
                //发送消息 修改UI线程中的组件  
                myHandler.sendMessage(msg);  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
    }
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
	
	
}
