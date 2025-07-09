import { getFullnodeUrl, SuiClient } from '@mysten/sui/client';
import { WalrusClient } from '@mysten/walrus';
import { Ed25519Keypair } from '@mysten/sui/keypairs/ed25519';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

async function main() {
  console.log('🌊 Walrus Basic Example - Store and Retrieve Blob');
  console.log('=====================================================\n');

  try {
    // Initialize Sui client
    const suiClient = new SuiClient({
      url: getFullnodeUrl('testnet'),
    });

    // Initialize Walrus client
    const walrusClient = new WalrusClient({
      network: 'testnet',
      suiClient,
    });

    // Create keypair from private key (replace with your own)
    const privateKey = process.env.SUI_PRIVATE_KEY;
    if (!privateKey) {
      throw new Error('Please set SUI_PRIVATE_KEY in your .env file');
    }

    const keypair = Ed25519Keypair.fromSecretKey(
      Buffer.from(privateKey, 'hex')
    );

    console.log('📝 Storing blob...');
    
    // Create sample data
    const sampleData = JSON.stringify({
      message: 'Hello from Walrus!',
      timestamp: new Date().toISOString(),
      author: 'Walrus Learning Repository',
      data: {
        numbers: [1, 2, 3, 4, 5],
        nested: {
          value: 'This is nested data',
          active: true
        }
      }
    }, null, 2);

    const blob = new TextEncoder().encode(sampleData);

    // Store the blob
    const storeResult = await walrusClient.writeBlob({
      blob,
      deletable: false,
      epochs: 3, // Store for 3 epochs (~3 days)
      signer: keypair,
    });

    console.log('✅ Blob stored successfully!');
    console.log(`📋 Blob ID: ${storeResult.blobId}`);
    console.log(`📏 Size: ${blob.length} bytes`);
    console.log(`⏰ Storage epochs: 3\n`);

    // Retrieve the blob
    console.log('📥 Retrieving blob...');
    const retrievedBlob = await walrusClient.readBlob({
      blobId: storeResult.blobId,
    });

    const retrievedData = new TextDecoder().decode(retrievedBlob);
    console.log('✅ Blob retrieved successfully!');
    console.log('📄 Retrieved data:');
    console.log(retrievedData);

    // Verify data integrity
    const isDataIntact = sampleData === retrievedData;
    console.log(`\n🔍 Data integrity check: ${isDataIntact ? '✅ PASSED' : '❌ FAILED'}`);

    if (isDataIntact) {
      console.log('\n🎉 Success! Your blob was stored and retrieved correctly.');
    } else {
      console.log('\n❌ Warning: Retrieved data differs from original data.');
    }

    // Additional information
    console.log('\n📊 Summary:');
    console.log(`   • Blob ID: ${storeResult.blobId}`);
    console.log(`   • Original size: ${blob.length} bytes`);
    console.log(`   • Retrieved size: ${retrievedBlob.length} bytes`);
    console.log(`   • Storage duration: 3 epochs`);
    console.log(`   • Deletable: No`);

  } catch (error) {
    console.error('❌ Error:', error);
    
    if (error instanceof Error) {
      console.error('Error message:', error.message);
      
      // Provide helpful error messages
      if (error.message.includes('insufficient')) {
        console.error('\n💡 Tip: Make sure you have enough SUI and WAL tokens');
      } else if (error.message.includes('network')) {
        console.error('\n💡 Tip: Check your network connection and try again');
      } else if (error.message.includes('private key')) {
        console.error('\n💡 Tip: Set your SUI_PRIVATE_KEY in the .env file');
      }
    }
  }
}

if (require.main === module) {
  main().catch(console.error);
} 