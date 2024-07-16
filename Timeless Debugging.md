### terminology
n = memory domain size			(max ~1GB  = 1,073,741,824)

m = number of execution queries		(max ~100M = 100,000,000)

### links
[Tenet](https://blog.ret2.io/2021/04/20/tenet-trace-explorer/) - A working plugin with bad time/memory efficiency

[PIN Tracer](https://github.com/gaasedelen/tenet/blob/master/tracers/pin/README.md) - Custom made tracer for tenet

[Persistent Tree Implementation](https://usaco.guide/adv/persistent?lang=cpp) - A USACO persistent tree implementation example

[Extending Python](https://docs.python.org/3/extending/extending.html) - Writing C code into python

[Statifier](https://sourceforge.net/projects/statifier/) - Convert dinamically linked executables to statically linked

[Cython docs](https://cython.readthedocs.io/en/latest/) - Cython documentation

[Arch detector](https://stackoverflow.com/questions/152016/detecting-cpu-architecture-compile-time) - Auto host architecture detection on compile time by boost

### deps
* native compiler
* add `"${workspaceFolder}/backend/deps/**/include/"` to includePath in vscode
```bash
pip install cython
pip install --upgrade setuptools
pip install --upgrade build
```

## Structures
missing definition of: `pst_node`, `tsize_t`
### context

| member    | type                                  |
| --------- | ------------------------------------- |
| timepoint | size_t                                |
| regs      | [[Timeless Debugging#registers\|registers]]   |
| mem       | pst_node                              |
| memacs    | [[Timeless Debugging#mem_access\|mem_access]] |
### registers
`NOTE: this part is architecture specific. assuming x86 for simplicitly`

| member | type       |
| ------ | ---------- |
| eax    | uint32_t   |
| ebx    | uint32_t   |
| ecx    | uint32_t   |
| edx    | uint32_t   |
| ebp    | uint32_t   |
| esp    | uint32_t   |
| esi    | uint32_t   |
| edi    | uint32_t   |
| eip    | uint32_t   |
| flags  | uint32_t   |
### mem_access

| member | type                                    |
| ------ | --------------------------------------- |
| addr   | tsize_t                                 |
| type   | [[Timeless Debugging#access_type\|access_type]] |
| len    | tsize_t                                 |
| value  | uint_8t*                                |
### access_type: enum

| member       | value         |
| ------------ | ------------- |
| ACCESS_READ  | 1 << 00 = 0x1 |
| ACCESS_WRITE | 1 << 01 = 0x2 |
### eip_entry

| member   | type                             |
| -------- | -------------------------------- |
| eip      | tsize_t                          |
| contexts | [[Timeless Debugging#context\|context]]* |
### access_entry

| member   | type                                  |
| -------- | ------------------------------------- |
| memacs   | [[Timeless Debugging#mem_access\|mem_access]] |
| contexts | [[Timeless Debugging#context\|context]]*      |

### mem_access_node

| member  | type                                                   |
| ------- | ------------------------------------------------------ |
| type    | [[Timeless Debugging#node_access_type enum\|node_access_type]] |
| value   | tsize_t                                                |
| other   | [[Timeless Debugging#mem_access_node\|mem_access_node]]*       |
| context | [[Timeless Debugging#context\|context]]*                       |
### node_access_type: enum

| member     | value         |
| ---------- | ------------- |
| TYPE_LEFT  | 1 << 00 = 0x1 |
| TYPE_RIGHT | 1 << 01 = 0x2 |
## initial parsing
each execution query creates a new context in a list.
context stores a persistent sparse tree for persistent memory access,
and registers as context.
building tree is 		t: O(1)		m: O(1)
each execution query is 	t: O(log(n))	m: O(log(n))
 * creates a context structure into list of contexts

full persistent build is 	t: O(m\*log(n))	m: O(m\*log(n))

## main features
1. search for all executions of an opcode or range of opcodes
sparse segment tree over list of contexts by EIP
build tree is		t: O(m\*log(m))	m: O(m)
query opcode is		t: O(log(m))
 * returns a list of context indices
2. search for all accesses to an address or address range
store an ordered list of left's right's with each one pointing to its relative left/right and its context.
perform a `lower_bound` search for l and `upper_bound` search for r, filter out dups and you have it
for reference: ordered list of mem_access_node's by value
build list is		t: O(m\*log(m)) m: O(m)
query address range is	t: O(log(m))
 * returns a list of timepoints when any value in address range has changed
3. search for all occurrences of immediate value with arbitrary length
for each mem access in `addr` for length `len`, search for value in range `(addr-len(value), addr+len+len(value))`
build tree is	already built
query value is 	t: O(m\*(log(n)+length))
 * returns a list of timepoints when `value` appears in memory (TODO: for each timepoint present all occurrences)
4. find function with queries that 

## additional features
1. filter timepoints result with conditions
just a high level, pythonic filter for register and memory values
which filters timeline result from (e.g. EAX=0 and ZF=1)
2. search for all occurrences of a regex value
if regex is fixed length, use the same method as [main features::3].
else IDK
3. optimize memory by storing up to X contexts
this means that user must choose which range he is now inspecting
maybe multi range support
4. add related timepoints as a view/highlighted in timeline for specific cases:
	* automatically find matching malloc/free calls
	* more?
5. mark a range of memory as a structure, allowing easy formatted data view, optionally limiting the mark to a range of execution (can work well with `4 -> automatic malloc/free calls`)
6. find function executions filtering arguments by value/pointer to value, by order, any of the arguments, etc.
## additional thoughts and notes
 * maybe persistent sparse tree for registers also to save memory?
 * maybe optimize 0-255 values like python does to reduce memory usage?