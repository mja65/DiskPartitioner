function Add-TypesScanningFreeSpace {
    param (
      
    )
    
    # Load C# helper for fast scanning

    Add-Type -TypeDefinition @"
using System;
using System.IO;

public static class EmptySpaceScanFile
{
    // Default forward scan
    public static long FindLastNonZeroByte(string path, int chunkSize)
    {
        return FindLastNonZeroByteForward(path, chunkSize, 0);
    }

    // Forward scan from offset
    public static long FindLastNonZeroByteForward(string path, int chunkSize, long startOffset)
    {
        using (FileStream fs = File.OpenRead(path))
        {
            if (startOffset > 0)
            {
                fs.Seek(startOffset, SeekOrigin.Begin);
            }

            byte[] buffer = new byte[chunkSize];
            long lastUsed = 0;
            long offset = startOffset;

            while (true)
            {
                int read = fs.Read(buffer, 0, chunkSize);
                if (read == 0) break;

                for (int i = read - 1; i >= 0; i--)
                {
                    if (buffer[i] != 0)
                    {
                        long pos = offset + i + 1;
                        if (pos > lastUsed)
                            lastUsed = pos;
                        break;
                    }
                }

                offset += read;
            }

            return lastUsed;
        }
    }

    // Reverse scan from offset
    public static long FindLastNonZeroByteReverse(string path, int chunkSize, long? startOffset = null)
    {
        using (FileStream fs = File.OpenRead(path))
        {
            long fileSize = fs.Length;
            long offset = startOffset ?? fileSize;

            if (offset > fileSize) offset = fileSize;

            byte[] buffer = new byte[chunkSize];
            long lastUsed = 0;

            while (offset > 0)
            {
                int toRead = (int)Math.Min(chunkSize, offset);
                offset -= toRead;
                fs.Seek(offset, SeekOrigin.Begin);

                int read = fs.Read(buffer, 0, toRead);
                if (read == 0) break;

                for (int i = read - 1; i >= 0; i--)
                {
                    if (buffer[i] != 0)
                    {
                        long pos = offset + i + 1;
                        if (pos > lastUsed)
                            lastUsed = pos;
                        return lastUsed; // Found the last non-zero, return immediately
                    }
                }
            }

            return lastUsed;
        }
    }
}
"@

Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;

public static class EmptySpaceScanDisk
{
    private const uint GENERIC_READ = 0x80000000;
    private const uint OPEN_EXISTING = 3;
    private const uint FILE_SHARE_READ = 0x00000001;
    private const uint FILE_SHARE_WRITE = 0x00000002;

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    private static extern SafeFileHandle CreateFile(
        string lpFileName,
        uint dwDesiredAccess,
        uint dwShareMode,
        IntPtr lpSecurityAttributes,
        uint dwCreationDisposition,
        uint dwFlagsAndAttributes,
        IntPtr hTemplateFile
    );

    public static long FindLastNonZeroByteReverse(string path, int chunkSize, long? startOffset = null)
    {
        SafeFileHandle handle = CreateFile(
            path,
            GENERIC_READ,
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            IntPtr.Zero,
            OPEN_EXISTING,
            0,
            IntPtr.Zero
        );

        if (handle.IsInvalid)
            throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());

        using (FileStream fs = new FileStream(handle, FileAccess.Read))
        {
            long diskSize = fs.Length;
            long offset = startOffset ?? diskSize;

            if (offset > diskSize) offset = diskSize;

            byte[] buffer = new byte[chunkSize];
            long lastUsed = 0;

            while (offset > 0)
            {
                int toRead = (int)Math.Min(chunkSize, offset);
                offset -= toRead;
                fs.Seek(offset, SeekOrigin.Begin);

                int read = fs.Read(buffer, 0, toRead);
                if (read == 0) break;

                for (int i = read - 1; i >= 0; i--)
                {
                    if (buffer[i] != 0)
                    {
                        long pos = offset + i + 1;
                        if (pos > lastUsed)
                            lastUsed = pos;
                        return lastUsed;
                    }
                }
            }

            return lastUsed;
        }
    }
}
"@


# Add-Type -TypeDefinition @"
# using System;
# using System.IO;

# public static class EmptySpaceScanFile
# {
#     public static long FindLastNonZeroByte(string path, int chunkSize)
#     {
#         using (FileStream fs = File.OpenRead(path))
#         {
#             byte[] buffer = new byte[chunkSize];
#             long lastUsed = 0;
#             long offset = 0;

#             while (true)
#             {
#                 int read = fs.Read(buffer, 0, chunkSize);
#                 if (read == 0) break;

#                 for (int i = read - 1; i >= 0; i--)
#                 {
#                     if (buffer[i] != 0)
#                     {
#                         long pos = offset + i + 1;
#                         if (pos > lastUsed)
#                             lastUsed = pos;
#                         break; // No need to check further in this block
#                     }
#                 }

#                 offset += read;
#             }

#             return lastUsed;
#         }
#     }
# }
# "@

# Add-Type -TypeDefinition @"
# using System;
# using System.IO;

# public static class EmptySpaceScanDisk
# {
#     public static long FindLastNonZeroByte(string path, int chunkSize, long maxLength)
#     {
#         using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
#         {
#             byte[] buffer = new byte[chunkSize];
#             long lastUsed = 0;
#             long offset = 0;

#             while (offset < maxLength)
#             {
#                 int toRead = chunkSize;
#                 if (offset + toRead > maxLength)
#                     toRead = (int)(maxLength - offset);

#                 int read = fs.Read(buffer, 0, toRead);
#                 if (read == 0) break;

#                 for (int i = read - 1; i >= 0; i--)
#                 {
#                     if (buffer[i] != 0)
#                     {
#                         long pos = offset + i + 1;
#                         if (pos > lastUsed)
#                             lastUsed = pos;
#                         break;
#                     }
#                 }

#                 offset += read;
#             }

#             return lastUsed;
#         }
#     }
# }
# "@

}