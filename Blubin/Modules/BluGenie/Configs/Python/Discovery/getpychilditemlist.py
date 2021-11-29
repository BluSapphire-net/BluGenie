'''
    .DESCRIPTION
        getpychilditemlist is a file meta data parser.  currently you can parse using regex based on the following properties
            o fullname (Default)
            o hashmd5
            o hashsha1
            o hashsha256
            o hashsha384
            o hashsha512

    .PARAMETER --help
        Description: Print this message and exit
        Notes: 
        Alias: -h
		
	.PARAMETER --path=<str>
        Description: The path to start the search from
        Notes: 
        Alias: -p=<str>
		
	.PARAMETER --pattern=<str>
        Description: Search Pattern using RegEx
        Notes: The default RegEx pattern is (.*)
        Alias: -pt=<str>
		
	.PARAMETER --filtertype=<int>
        Description: Select which property table to parse using the property ID
        Notes:  0 = Query the (fullname) value (Default)
                1 = Query the (hashmd5) value
                2 = Query the (hashsha1) value
                3 = Query the (hashsha256) value
                4 = Query the (hashsha384) value
                5 = Query the (hashsha512) value
        Alias: -ft=<int>
		
	.PARAMETER --hash
        Description: Specifies the cryptographic hash value of the contents of the specified file.
        Notes: The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
        Alias: -hs
		
	.PARAMETER --recurse
        Description: Recurse through subdirectories
        Notes: 
        Alias: -r

    .PARAMETER --adscheck
        Description: Scan for Alternate Data Streams
        Notes: 
        Alias: -ads

    .PARAMETER --outyaml
        Description: Output return data as YAML Format
        Notes: 
        Alias: -oy

    .PARAMETER --outjson
        Description: Output return data as JSON Format (Default)
        Notes: 
        Alias: -oj

    .PARAMETER --outstring
        Description: Output return data as a String
        Notes: 
        Alias: -os

    .PARAMETER --outcsv
        Description: Output return data as a CSV
        Notes: 
        Alias: -oc

    .PARAMETER --verbose
        Description: Verbose Output.  Display each parameter and set value
        Notes: Since stdout is updated with verbose data, the normal output cannot be
                piped cleanly to another command
        Alias: -v

    .PARAMETER --verboseonly
        Description: Only show the Verbose Output.  This will not run the command.
        Notes: 
        Alias: -vo

    .EXAMPLE
        Command: python .\getchilditemlist.py -h
        Description: Print the command help reference
        Notes:
		
	.EXAMPLE
        Command: python .\getchilditemlist.py --path="c:\\windows\\temp" --hash -r
        Description: Parse the C:\Windows\Temp and sub directories for all files including the Hash information
        Notes:
		
	.EXAMPLE 
        Command: python .\getchilditemlist.py --path="c:\\windows\\temp" --hash -r -v
        Description: Print the Parameter values and internal call command prior to running the Parse command
        Notes:
		
	.EXAMPLE
        Command: python .\getchilditemlist.py --path="c:\\windows\\temp" --hash --verboseonly
        Description: Print the Verbose output only.  This will not run the Parse process
        Notes:
		
	.EXAMPLE
        Command: python .\getchilditemlist.py -p="c:\\windows\\temp" -pt"\.exe$|\.bat$" -hs -ads
        Description: Parse for all *.exe and *.bat file in C:\Windows\Temp.  Include Hash and Alternate Data Stream information
        Notes:
		
	.EXAMPLE
        Command: python .\getchilditemlist.py -p="c:\\windows\\temp" -pt"\.exe$|\.bat$" -h -ads | Convertfrom-json
        Description: Pipe the return JSON data into PowerShell's Convert From JSON cmd to rebuild the data as PS Objects.
        Notes:

    .EXAMPLE
        Command: python .\getchilditemlist.py -p="c:\\windows\\temp" -pt"\.exe$|\.bat$" -h -ads --outyaml
        Description: Display the retuen data in YAML format
        Notes:

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.07.0601 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [Python Compatibility]
            o  3.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  os -> reference https://docs.python.org/3/library/os.html
            o  json -> reference https://docs.python.org/3/library/json.html
            o  regex -> reference https://pypi.org/project/regex/
            o  time -> reference https://docs.python.org/3/library/time.html
            o  yaml -> reference https://pyyaml.org/wiki/PyYAMLDocumentation
            o  hashlib -> reference https://docs.python.org/3/library/hashlib.html	
            o  win32api -> reference http://timgolden.me.uk/pywin32-docs/
            o  pyADS -> reference https://github.com/RobinDavid/pyADS
            o  pyADS import ADS -> reference https://github.com/RobinDavid/pyADS
            o  sys -> reference https://docs.python.org/3/library/sys.html
		• [Build Notes]
            o  21.07.0601
				• [Michael Arroyo] Added support for CLI
                • [Michael Arroyo] Added support for JSON formatted return data
                • [Michael Arroyo] Added support for YAML formatted return data
                • [Michael Arroyo] Added support for String formatted return data
                • [Michael Arroyo] Added support for CSV formatted return data
                • [Michael Arroyo] Updated .Py file Help information
                • [Michael Arroyo] Updated get_childitemlist API Help information
                • [Michael Arroyo] Updated Hash chucks to use up less memory when parsing a file (1024)
                • [Michael Arroyo] Updated Hash flag to <bool> instead of Hash String Type.  Now all Hash values are processed and added to the return
                • [Michael Arroyo] Added a CLI help menu defining all the parameters
                • [Michael Arroyo] Fixed Extension check.  Process was terminating early if the file didn't have an Extension.
'''

#
#[ Import Modules ]
#
import os 					#code reference https://docs.python.org/3/library/os.html
import json					#code reference https://docs.python.org/3/library/json.html
import regex				#code reference https://pypi.org/project/regex/
import time					#code reference https://docs.python.org/3/library/time.html
import yaml                 #code reference https://pyyaml.org/wiki/PyYAMLDocumentation
import hashlib				#code reference https://docs.python.org/3/library/hashlib.html	
import win32api				#code reference http://timgolden.me.uk/pywin32-docs/
import pyADS				#code reference https://github.com/RobinDavid/pyADS
from pyADS import ADS		#code reference https://github.com/RobinDavid/pyADS
import sys					#code reference https://docs.python.org/3/library/sys.html

#
#[ Functions ]
#
def get_childitemlist(path,
    pattern = '.*',
    recurse = False,
    hash = False,
    adscheck = False,
    filtertype = "0"):
    '''
    .DESCRIPTION
        get_childitemlist is a file meta data parser.  currently you can parse using regex based on the following properties
            o fullname (Default)
            o hashmd5
            o hashsha1
            o hashsha256
            o hashsha384
            o hashsha512

    .PARAMETER path=<str>
        Description: The path to start the search from
        Notes: 
        Alias: 
		
	.PARAMETER pattern=<str>
        Description: Search Pattern using RegEx
        Notes: The default RegEx pattern is (.*)
        Alias: 
		
	.PARAMETER filtertype=<str>
        Description: Select which property table to parse using the property ID
        Notes:  0 = Query the (fullname) value (Default)
                1 = Query the (hashmd5) value
                2 = Query the (hashsha1) value
                3 = Query the (hashsha256) value
                4 = Query the (hashsha384) value
                5 = Query the (hashsha512) value
        Alias: 
		
	.PARAMETER hash=<bool>
        Description: Specifies the cryptographic hash value of the contents of the specified file.
        Notes: The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
        Alias: 
		
	.PARAMETER recurse=<bool>
        Description: Recurse through subdirectories
        Notes: 
        Alias:

    .PARAMETER adscheck=<bool>
        Description: Scan for Alternate Data Streams
        Notes: 
        Alias:

    .EXAMPLE
        Command: from getpychilditemlist import get_childitemlist
                 help(get_childitemlist)
        Description: Print the command help reference
        Notes:
		
	.EXAMPLE
        Command: from getpychilditemlist import get_childitemlist 
                 get_childitemlist(path='c:\\windows\\temp', hash=True, recurse=True)
        Description: Parse the C:\Windows\Temp and sub directories for all files including the Hash information
        Notes:
		
	.EXAMPLE
        Command: from getpychilditemlist import get_childitemlist 
                 get_childitemlist(path='c:\\windows\\temp', pattern='\.exe$|\.bat$', hash=True, adscheck=True)
        Description: Parse for all *.exe and *.bat file in C:\Windows\Temp.  Include Hash and Alternate Data Stream information
        Notes:
		
    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.07.0601 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [Python Compatibility]
            o  3.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  os -> reference https://docs.python.org/3/library/os.html
            o  regex -> reference https://pypi.org/project/regex/
            o  time -> reference https://docs.python.org/3/library/time.html
            o  hashlib -> reference https://docs.python.org/3/library/hashlib.html	
            o  win32api -> reference http://timgolden.me.uk/pywin32-docs/
            o  pyADS -> reference https://github.com/RobinDavid/pyADS
            o  pyADS import ADS -> reference https://github.com/RobinDavid/pyADS
            o  sys -> reference https://docs.python.org/3/library/sys.html
		• [Build Notes]
            o  21.07.0601
				• [Michael Arroyo] Posted
				
    '''

    #print('    get_childitemlist(path="{}", pattern="{}", hash="{}", recurse="{}", adscheck="{}", filtertype="{}")'.format(path, pattern, hash, recurse, adscheck, filtertype))

    class fileobject:
        def __init__(self):
            self.fullname = ''
            self.path = ''
            self.name = ''
            self.shortpath = ''
            self.shortname = ''
            self.sizeinbytes = 0
            self.iscontainer = 'false'
            self.extension = ''
            self.creationtime = ''
            self.creationtimeutc = ''
            self.lastaccesstime = ''
            self.lastaccesstimeutc = ''
            self.lastwritetime = ''
            self.lastwritetimeutc = ''
            self.attributes = ''
            self.hashsha1 = ''
            self.hashsha256 = ''
            self.hashsha384 = ''
            self.hashsha512 = ''
            self.hashmd5 = ''
            self.ads = 'false'
            self.streams = []
            self.signature_comment = ''
            self.signature_fileversion = ''
            self.signature_description = ''
            self.signature_date = ''
            self.signature_company = ''
            self.signature_publisher = ''
            self.signature_verified = ''
            self.permissions = []
            self.owner = ''
            self.streamcontent = []
            self.removed = []

        def __str__(self):
                for key,value in self.__dict__.items():
                    print('{} = {}'.format(key,value))

        def __repr__(self):
            reprstring = '<__main__.fileobject: '
            reprcount = self.__dict__.items().__len__()
            reprcounter = 0
            for key,value in self.__dict__.items():
                    reprstring = reprstring + (' {} = "{}"'.format(key,value))
                    reprcounter += 1
                    if reprcounter < reprcount:
                        reprstring = reprstring + ';'
            reprstring = reprstring + '>'
            return reprstring

    def attribinttostring(attrib):
        '''
        Convert Attribute Int value to readable text
        :param attrib:
        :return:
            NORMAL     = 0    Normal file. No attributes are set.
            READONLY   = 1    Read-only file. Attribute is read/write.
            HIDDEN     = 2    Hidden file. Attribute is read/write.
            SYSTEM     = 4    System file. Attribute is read/write.
            VOLUME     = 8    Disk drive volume label. Attribute is read-only.
            DIRECTORY  = 16   Folder or directory. Attribute is read-only.
            ARCHIVE    = 32   File has changed since last backup. Attribute is read/write.
            ALIAS      = 1024 Link or shortcut. Attribute is read-only.
            COMPRESSED = 2048 Compressed file. Attribute is read-only.
        '''
        NORMAL     = 0    #Normal file. No attributes are set.
        READONLY   = 1    #Read-only file. Attribute is read/write.
        HIDDEN     = 2    #Hidden file. Attribute is read/write.
        SYSTEM     = 4    #System file. Attribute is read/write.
        VOLUME     = 8    #Disk drive volume label. Attribute is read-only.
        DIRECTORY  = 16   #Folder or directory. Attribute is read-only.
        ARCHIVE    = 32   #File has changed since last backup. Attribute is read/write.
        ALIAS      = 1024 #Link or shortcut. Attribute is read-only.
        COMPRESSED = 2048 #Compressed file. Attribute is read-only.

        returnstring = []

        if not (attrib - COMPRESSED) < 0:
            returnstring.append('compressed')
            attrib = (attrib - COMPRESSED)
        if not (attrib - ALIAS) < 0:
            returnstring.append('alias')
            attrib = (attrib - ALIAS)
        if not (attrib - ARCHIVE) < 0:
            returnstring.append('archive')
            attrib = (attrib - ARCHIVE)
        if not (attrib - DIRECTORY) < 0:
            returnstring.append('directory')
            attrib = (attrib - DIRECTORY)
        if not (attrib - VOLUME) < 0:
            returnstring.append('volume')
            attrib = (attrib - VOLUME)
        if not (attrib - SYSTEM) < 0:
            returnstring.append('system')
            attrib = (attrib - SYSTEM)
        if not (attrib - HIDDEN) < 0:
            returnstring.append('hidden')
            attrib = (attrib - HIDDEN)
        if not (attrib - READONLY) < 0:
            returnstring.append('readonly')
            attrib = (attrib - READONLY)

        return returnstring

    def hashvalue(path):
        '''
        Process Hash Value

        :param path: path to folder or directory [Note: if using a string make sure to use r'' to set the string as RAW]
        :return: ** Values **
                sha1,
                sha256,
                sha384,
                sha512,
                md5
        '''

        class hashes():
            def __init__(self):
                self.hashsha1 = ''
                self.hashsha256 = ''
                self.hashsha384 = ''
                self.hashsha512 = ''
                self.hashmd5 = ''

            def __str__(self):
                for key,value in self.__dict__.items():
                    print('{} = {}'.format(key,value))
                return

        file_hashsha1   = hashlib.sha1()
        file_hashsha256 = hashlib.sha256()
        file_hashsha384 = hashlib.sha384()
        file_hashsha512 = hashlib.sha512()
        file_hashmd5    = hashlib.md5()

        with open(path,'rb') as file:
            # loop till the end of the file
            chunk = 0
            while chunk != b'':
                # read only 1024 bytes at a time
                chunk = file.read(1024)
                file_hashsha1.update(chunk)
                file_hashsha256.update(chunk)
                file_hashsha384.update(chunk)
                file_hashsha512.update(chunk)
                file_hashmd5.update(chunk)

        h = hashes()
        h.hashsha1 = file_hashsha1.hexdigest()
        h.hashsha256 = file_hashsha256.hexdigest()
        h.hashsha384 = file_hashsha384.hexdigest()
        h.hashsha512 = file_hashsha512.hexdigest()
        h.hashmd5 = file_hashmd5.hexdigest()

        return(h)

    def processfileinfo(self):
        class objnamevalue:
            def __int__(self):
                self.name = ''
                self.value = ''

            def __str__(self):
                print(f'name = {self.name}' +
                      f'\ndatavalue = {self.value}')


        curfile = os.stat(self.fullname)
        self.creationtime = time.ctime(curfile.st_ctime)
        self.lastaccesstime = time.ctime(curfile.st_atime)
        self.lastwritetime = time.ctime(curfile.st_mtime)
        self.sizeinbytes = curfile.st_size
        try:
            self.extension = self.fullname.rsplit('.', 1)[1]
        except:
            pass

        try:
            self.shortname = win32api.GetShortPathName(self.fullname)
        except:
            pass

        try:
            self.shortpath = win32api.GetShortPathName(self.path)
        except:
            pass

        try:
            self.attributes = attribinttostring(win32api.GetFileAttributes(self.fullname))
        except:
            pass

        if not hash == False:
            try:
                h = hashvalue(self.fullname)
                self.hashsha1 = h.hashsha1
                self.hashsha256 = h.hashsha256
                self.hashsha384 = h.hashsha384
                self.hashsha512 = h.hashsha512
                self.hashmd5 = h.hashmd5
            except:
                self.hash = sys.last_value.__str__()

        if adscheck == True:
            handler = ADS(self.fullname)
            if handler.has_streams():
                self.ads = 'true'
                for stream in handler:
                    streamcontent = objnamevalue()
                    streamcontent.name = stream
                    streamcontent.value = handler.get_stream_content(stream).decode('utf-8')
                    self.streams.append(stream)
                    self.streamcontent.append(streamcontent.__dict__)
                    del streamcontent

        return self

    arrresult = []

    if recurse == True:
        for root, dirs, files in os.walk(path):
            for name in files:
                if os.path.isfile(os.path.join(root, name)):
                    if filtertype == "0":
                        if regex.findall(pattern, os.path.join(root, name), 2):
                            objfile = fileobject()
                            objfile.fullname = (os.path.join(root, name))
                            objfile.path = root
                            objfile.name = name
                            objfile = processfileinfo(objfile)
                            arrresult.append(objfile)
                            del objfile
                    else:
                        objfile = fileobject()
                        objfile.fullname = (os.path.join(root, name))
                        objfile.path = root
                        objfile.name = name
                        objfile = processfileinfo(objfile)

                        if filtertype == "1":
                            if regex.findall(pattern, objfile.hashmd5, 2):
                                arrresult.append(objfile)
                        elif filtertype == "2":
                            if regex.findall(pattern, objfile.hashsha1, 2):
                                arrresult.append(objfile)
                        elif filtertype == "3":
                            if regex.findall(pattern, objfile.hashsha256, 2):
                                arrresult.append(objfile)
                        elif filtertype == "4":
                            if regex.findall(pattern, objfile.hashsha384, 2):
                                arrresult.append(objfile)
                        elif filtertype == "5":
                            if regex.findall(pattern, objfile.hashsha512, 2):
                                arrresult.append(objfile)
                                
                        del objfile
    else:
        for file in os.listdir(path):
            if os.path.isfile((os.path.join(path, file))):
                if filtertype == "0":
                    if regex.findall(pattern, file, 2):
                        objfile = fileobject()
                        objfile.fullname = (os.path.join(path, file))
                        objfile.path = path
                        objfile.name = file
                        objfile = processfileinfo(objfile)
                        arrresult.append(objfile)
                        del objfile
                else:
                    objfile = fileobject()
                    objfile.fullname = (os.path.join(path, file))
                    objfile.path = path
                    objfile.name = file
                    objfile = processfileinfo(objfile)

                    if filtertype == "1":
                        if regex.findall(pattern, objfile.hashmd5, 2):
                            arrresult.append(objfile)
                    elif filtertype == "2":
                        if regex.findall(pattern, objfile.hashsha1, 2):
                            arrresult.append(objfile)
                    elif filtertype == "3":
                        if regex.findall(pattern, objfile.hashsha256, 2):
                            arrresult.append(objfile)
                    elif filtertype == "4":
                        if regex.findall(pattern, objfile.hashsha384, 2):
                            arrresult.append(objfile)
                    elif filtertype == "5":
                        if regex.findall(pattern, objfile.hashsha512, 2):
                            arrresult.append(objfile)
                    
                    del objfile
    return arrresult

def ModHelp():
    "This displays the current Help information for this Module"
    myhelp = '''
Usage:
  getchilditemlist <options>

Options:
  -h,           --help             : Print this message and exit
  -p=<str>,     --path=<str>       : The path to start your search from
  -pt=<str>,    --pattern=<str>    : Search Pattern using RegEx
                                       o Note:  The default RegEx pattern is (.*) which is all files
  -ft=<int>,    --filtertype=<int> : Select which property table to parse using the pattern value
                                       0 = Query the (fullname) value (Default)
                                       1 = Query the (hashmd5) value
                                       2 = Query the (hashsha1) value
                                       3 = Query the (hashsha256) value
                                       4 = Query the (hashsha384) value
                                       5 = Query the (hashsha512) value
  -hs,          --hash             : Specifies the cryptographic hash value of the contents of the specified file.
                                       o The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
  -r,           --recurse          : Recurse through subdirectories
  -ads,         --adscheck         : Scan for Alternate Data Streams
  -oy,          --outyaml          : Output return data as YAML Format
  -oj,          --outjson          : Output return data as JSON Format (Default)
  -os,          --outstring        : Output return data as a String
  -oc,          --outcsv           : Output return data as a CSV
  -v,           --verbose          : Verbose Output.  Display each parameter and set value
  -vo,          --verboseonly      : Only show the Verbose Output.  This will not run the command.

Examples:
  - python .\getchilditemlist.py -h
  - python .\getchilditemlist.py --path="c:\\windows\\temp" --hash -r
  - python .\getchilditemlist.py --path="c:\\windows\\temp" --hash -r -v
  - python .\getchilditemlist.py --path="c:\\windows\\temp" --hash --verboseonly
  - python .\getchilditemlist.py -p="c:\\windows\\temp" -pt"\.exe$|\.bat$" -h -ads
    '''
    print(myhelp)
    
commandline = ' '.join(sys.argv[1:])

#region
if regex.match('-h$|--help$', commandline, 2):
    ModHelp()
elif commandline != '':
    clipath = ''
    clipattern = '.*'
    clihash = False
    clifiltertype = "0"
    clirecurse = False
    cliadscheck = False
    clioutyaml = False
    clioutjson = True
    clioutstring = False
    cliverbose = False
    cliverboseonly = False
    clioutcsv = False

    for arg in sys.argv:
        if regex.match('-p=|--path=', arg, 2):
            clipath = arg.replace('-p=','').replace('--path=','').strip()
        elif regex.match('-pt=|--pattern=', arg, 2):
            clipattern = arg.replace('-pt=','').replace('--pattern=','').strip()
        elif regex.match('-hs$|--hash$', arg, 2):
            clihash = True
        elif regex.match('-ft=|--filtertype=', arg, 2):
            clifiltertype = arg.replace('-ft=','').replace('--filtertype=','').strip()
        elif regex.match('-r$|--recurse$', arg, 2):
            clirecurse = True
        elif regex.match('-ads$|--adscheck$', arg, 2):
            cliadscheck = True
        elif regex.match('-oy$|--outyaml$', arg, 2):
            clioutyaml = True
            clioutjson = False
            clioutstring = False
            clioutcsv = False
        elif regex.match('-oc$|--outcsv$', arg, 2):
            clioutyaml = False
            clioutjson = False
            clioutstring = False
            clioutcsv = True
        elif regex.match('-os$|--outstring$', arg, 2):
            clioutyaml = False
            clioutjson = False
            clioutstring = True
            clioutcsv = False
        elif regex.match('-oj$|--outjson$', arg, 2):
            clioutyaml = False
            clioutjson = True
            clioutstring = False
            clioutcsv = False
        elif regex.match('-v$|--verbose$', arg, 2):
            cliverbose = True
        elif regex.match('-vo$|--verboseonly$', arg, 2):
            cliverboseonly = True
        
    if clipath == '':
        print('error: Path is not set.  Cannot continue.  Please review the help.')
        ModHelp()
        exit()
    
    if cliverbose == True or cliverboseonly == True:
        print('')
        print('Verbose Information:')
        print('  Parameter Values:')
        print('    path = {}'.format(clipath))
        print('    pattern = {}'.format(clipattern))
        print('    hash = {}'.format(clihash))
        print('    filtertype = {}'.format(clifiltertype))
        print('    recurse = {}'.format(clirecurse))
        print('    adscheck = {}'.format(cliadscheck))
        print('    outyaml = {}'.format(clioutyaml))
        print('    outjson = {}'.format(clioutjson))
        print('    outstring = {}'.format(clioutstring))
        print('    outcsv = {}'.format(clioutcsv))
        print('    verbose = {}'.format(cliverbose))
        print('    verboseonly = {}'.format(cliverboseonly))
        print('')
        print('  Function Call:')
        print('    get_childitemlist(path="{}", pattern="{}", hash="{}", recurse="{}", adscheck="{}", filtertype="{}")'.format(clipath, clipattern, clihash, clirecurse, cliadscheck, clifiltertype))
        print('')

    if cliverboseonly == False:
        result = get_childitemlist(path=clipath, pattern=clipattern, recurse=clirecurse, hash=clihash, adscheck=cliadscheck, filtertype=clifiltertype)
        
        if clioutstring == True:
            for item in result:
                print('fullname="{}"\npath="{}"\nname="{}"\nshortpath="{}"\nshortname="{}"\nsizeinbytes="{}"\niscontainer="{}"\nextension="{}"\ncreationtime="{}"\ncreationtimeutc="{}"\nlastaccesstime="{}"\nlastaccesstimeutc="{}"\nlastwritetime="{}"\nlastwritetimeutc="{}"\nattributes="{}"\nhashsha1="{}"\nhashsha256="{}"\nhashsha384="{}"\nhashsha512="{}"\nhashmd5="{}"\nads="{}"\nstreams="{}"\nsignature_comment="{}"\nsignature_fileversion="{}"\nsignature_description="{}"\nsignature_date="{}"\nsignature_company="{}"\nsignature_publisher="{}"\nsignature_verified="{}"\npermissions="{}"\nowner="{}"\nstreamcontent="{}"\nremoved="{}"\n'.format(item.__dict__.__getitem__('fullname').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('path').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('name').__str__(),item.__dict__.__getitem__('shortpath').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('shortname').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('sizeinbytes').__str__(),item.__dict__.__getitem__('iscontainer').__str__(),item.__dict__.__getitem__('extension').__str__(),item.__dict__.__getitem__('creationtime').__str__(),item.__dict__.__getitem__('creationtimeutc').__str__(),item.__dict__.__getitem__('lastaccesstime').__str__(),item.__dict__.__getitem__('lastaccesstimeutc').__str__(),item.__dict__.__getitem__('lastwritetime').__str__(),item.__dict__.__getitem__('lastwritetimeutc').__str__(),item.__dict__.__getitem__('attributes').__str__(),item.__dict__.__getitem__('hashsha1').__str__(),item.__dict__.__getitem__('hashsha256').__str__(),item.__dict__.__getitem__('hashsha384').__str__(),item.__dict__.__getitem__('hashsha512').__str__(),item.__dict__.__getitem__('hashmd5').__str__(),item.__dict__.__getitem__('ads').__str__(),item.__dict__.__getitem__('streams').__str__(),item.__dict__.__getitem__('signature_comment').__str__(),item.__dict__.__getitem__('signature_fileversion').__str__(),item.__dict__.__getitem__('signature_description').__str__(),item.__dict__.__getitem__('signature_date').__str__(),item.__dict__.__getitem__('signature_company').__str__(),item.__dict__.__getitem__('signature_publisher').__str__(),item.__dict__.__getitem__('signature_verified').__str__(),item.__dict__.__getitem__('permissions').__str__(),item.__dict__.__getitem__('owner').__str__(),item.__dict__.__getitem__('streamcontent').__str__(),item.__dict__.__getitem__('removed').__str__()))
        elif clioutcsv == True:
            print('"fullname","path","name","shortpath","shortname","sizeinbytes","iscontainer","extension","creationtime","creationtimeutc","lastaccesstime","lastaccesstimeutc","lastwritetime","lastwritetimeutc","attributes","hashsha1","hashsha256","hashsha384","hashsha512","hashmd5","ads","streams","signature_comment","signature_fileversion","signature_description","signature_date","signature_company","signature_publisher","signature_verified","permissions","owner","streamcontent","removed"')
            for item in result:
                print('"{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}","{}"'.format(item.__dict__.__getitem__('fullname').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('path').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('name').__str__(),item.__dict__.__getitem__('shortpath').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('shortname').__str__().replace("\\\\","\\"),item.__dict__.__getitem__('sizeinbytes').__str__(),item.__dict__.__getitem__('iscontainer').__str__(),item.__dict__.__getitem__('extension').__str__(),item.__dict__.__getitem__('creationtime').__str__(),item.__dict__.__getitem__('creationtimeutc').__str__(),item.__dict__.__getitem__('lastaccesstime').__str__(),item.__dict__.__getitem__('lastaccesstimeutc').__str__(),item.__dict__.__getitem__('lastwritetime').__str__(),item.__dict__.__getitem__('lastwritetimeutc').__str__(),item.__dict__.__getitem__('attributes').__str__(),item.__dict__.__getitem__('hashsha1').__str__(),item.__dict__.__getitem__('hashsha256').__str__(),item.__dict__.__getitem__('hashsha384').__str__(),item.__dict__.__getitem__('hashsha512').__str__(),item.__dict__.__getitem__('hashmd5').__str__(),item.__dict__.__getitem__('ads').__str__(),item.__dict__.__getitem__('streams').__str__(),item.__dict__.__getitem__('signature_comment').__str__(),item.__dict__.__getitem__('signature_fileversion').__str__(),item.__dict__.__getitem__('signature_description').__str__(),item.__dict__.__getitem__('signature_date').__str__(),item.__dict__.__getitem__('signature_company').__str__(),item.__dict__.__getitem__('signature_publisher').__str__(),item.__dict__.__getitem__('signature_verified').__str__(),item.__dict__.__getitem__('permissions').__str__(),item.__dict__.__getitem__('owner').__str__(),item.__dict__.__getitem__('streamcontent').__str__(),item.__dict__.__getitem__('removed').__str__()))
        elif clioutjson:
            curtotal = len(result)
            curcount = 1
            if len(result) > 1:
                print('[')
            for item in result:
                if curcount < curtotal:
                    
                    print(json.dumps(item.__dict__).replace('\\\\\\','\\'), end=',')
                    curcount += 1
                else:
                    print(json.dumps(item.__dict__).replace('\\\\\\','\\'))
            if len(result) > 1:
                print(']')
        elif clioutyaml:
            for item in result:
                print('---')
                print(yaml.dump(item.__dict__).replace('\\\\','\\').strip())
        else:
            print(result)
    
else:
    ModHelp()
#endregion