# Agent Memory Research: Advanced Memory Systems

Based on recent academic research and practical implementations for AI agents.

## Installation

Create memory research directory:
```bash
mkdir -p ~/.openclaw/workspace/memory/research
```

## Core Concepts

### Memory Taxonomy

#### By Form
- **Token-level**: Raw context tokens (short-term)
- **Parametric**: Model weights and fine-tuning (long-term)  
- **Latent**: Vector embeddings and semantic representations (medium-term)

#### By Function  
- **Factual**: Knowledge and information storage
- **Experiential**: Learning from past interactions and outcomes
- **Working Memory**: Current task context and active processing

### A-MEM System Implementation

Based on the NeurIPS 2025 paper "A-MEM: Zettelkasten-style Memory for Agents"

#### Key Features
- **Interconnected notes**: Each memory can link to related memories
- **Dynamic linking**: New memories can UPDATE existing ones
- **Semantic search**: Natural language queries across memory corpus
- **Automatic summarization**: Long memories are automatically condensed

## Implementation Guide

### 1. Memory Structure Setup

#### Create Memory Directories
```bash
# Factual memory (knowledge base)
mkdir -p ~/.openclaw/workspace/memory/factual

# Experiential memory (learning from experience)  
mkdir -p ~/.openclaw/workspace/memory/experiential

# Working memory (current tasks)
mkdir -p ~/.openclaw/workspace/memory/working
```

#### Memory File Format
Each memory entry should follow this JSON structure:
```json
{
  "id": "unique-memory-id",
  "type": "factual|experiential|working",
  "title": "Memory title",
  "content": "Main memory content",
  "tags": ["tag1", "tag2"],
  "links": ["memory-id-1", "memory-id-2"],
  "created_at": "2026-02-08T00:45:00Z",
  "updated_at": "2026-02-08T00:45:00Z",
  "confidence": 0.95,
  "source": "manual|automated|learning"
}
```

### 2. Memory Operations

#### Add New Memory
```bash
add_memory() {
    local type="$1"
    local title="$2" 
    local content="$3"
    local tags="$4"
    
    local memory_id=$(uuidgen)
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    cat > "~/.openclaw/workspace/memory/$type/$memory_id.json" << EOF
{
  "id": "$memory_id",
  "type": "$type",
  "title": "$title",
  "content": "$content",
  "tags": [$tags],
  "links": [],
  "created_at": "$timestamp",
  "updated_at": "$timestamp",
  "confidence": 0.9,
  "source": "manual"
}
EOF
}
```

#### Update Existing Memory
```bash
update_memory() {
    local memory_id="$1"
    local new_content="$2"
    local confidence="$3"
    
    # Find memory file
    local memory_file=$(find ~/.openclaw/workspace/memory -name "$memory_id.json" | head -1)
    
    if [ -f "$memory_file" ]; then
        # Update content and timestamp
        jq --arg content "$new_content" \
           --arg conf "$confidence" \
           --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
           '.content = $content | .confidence = ($conf | tonumber) | .updated_at = $timestamp' \
           "$memory_file" > "$memory_file.tmp" && mv "$memory_file.tmp" "$memory_file"
    fi
}
```

#### Link Memories
```bash
link_memories() {
    local source_id="$1"
    local target_id="$2"
    
    local source_file=$(find ~/.openclaw/workspace/memory -name "$source_id.json" | head -1)
    
    if [ -f "$source_file" ]; then
        jq --arg target "$target_id" \
           '.links += [$target] | .links |= unique' \
           "$source_file" > "$source_file.tmp" && mv "$source_file.tmp" "$source_file"
    fi
}
```

### 3. Semantic Search Integration

#### Vector Embedding Generation
```bash
generate_embeddings() {
    local memory_dir="$1"
    
    # Process all memory files and generate embeddings
    find "$memory_dir" -name "*.json" | while read -r memory_file; do
        local content=$(jq -r '.content' "$memory_file")
        local embedding=$(curl -s "http://localhost:8080/embed" -d "$content" | jq -r '.embedding')
        
        # Store embedding with memory
        jq --argjson emb "$embedding" \
           '.embedding = $emb' \
           "$memory_file" > "$memory_file.tmp" && mv "$memory_file.tmp" "$memory_file"
    done
}
```

#### Natural Language Search
```bash
search_memory() {
    local query="$1"
    local top_k="${2:-5}"
    
    # Generate query embedding
    local query_embedding=$(curl -s "http://localhost:8080/embed" -d "$query" | jq -r '.embedding')
    
    # Search across all memories
    find ~/.openclaw/workspace/memory -name "*.json" | while read -r memory_file; do
        local similarity=$(calculate_similarity "$query_embedding" "$memory_file")
        echo "$similarity $memory_file"
    done | sort -nr | head -n "$top_k"
}
```

## Integration with QMD

### Automatic Indexing
QMD can automatically index the structured memory files:

#### QMD Configuration
```json
{
  "memory": {
    "backend": "qmd",
    "qmd": {
      "includeDefaultMemory": true,
      "directories": [
        "~/.openclaw/workspace/memory/factual",
        "~/.openclaw/workspace/memory/experiential", 
        "~/.openclaw/workspace/memory/working"
      ],
      "filePattern": "**/*.json",
      "contentField": "content",
      "metadataFields": ["type", "title", "tags", "confidence"]
    }
  }
}
```

### Semantic Query Examples
With QMD integration, you can perform natural language queries:

- "What did I learn about缠论分型识别?"
- "Show me my experiential memories about task efficiency"
- "Find factual knowledge about K线数据获取"

## Practical Applications

### 1. Learning from Mistakes
Store failed task attempts in experiential memory:
```json
{
  "type": "experiential",
  "title": "Task Planning Overestimation",
  "content": "I consistently overestimated my ability to complete complex tasks in short timeframes. Actual completion time was 2-3x longer than estimated.",
  "tags": ["task-planning", "time-estimation", "lesson-learned"],
  "confidence": 0.95,
  "source": "learning"
}
```

### 2. Knowledge Base Building  
Store technical knowledge in factual memory:
```json
{
  "type": "factual", 
  "title": "缠论分型识别规则",
  "content": "顶分型：相邻的三根K线，中间高点最高，两侧低点不创新高。底分型：相邻的三根K线，中间低点最低，两侧高点不创新低。",
  "tags": ["缠论", "technical-analysis", "pattern-recognition"],
  "confidence": 0.98,
  "source": "manual"
}
```

### 3. Working Context Management
Store current task context in working memory:
```json
{
  "type": "working",
  "title": "Current Task: Skill Installation",
  "content": "Installing Skills 2/6/7/3/10 in sequence. Currently working on Skill 2 (Agent Memory Research).",
  "tags": ["task-management", "skill-installation", "current-context"],
  "confidence": 1.0,
  "source": "automated"
}
```

## Best Practices

1. **Categorize memories properly** by function (factual/experiential/working)
2. **Use consistent tagging** for easy retrieval and filtering
3. **Link related memories** to build knowledge networks
4. **Update confidence scores** based on verification and usage
5. **Regular maintenance** to clean up outdated or low-confidence memories
6. **Backup memory directories** regularly to prevent data loss

## Research References

- **"Memory in the Age of AI Agents"** (Dec 2025, arxiv 2512.13564)
- **A-MEM Paper** (NeurIPS 2025): github.com/WujiangXu/A-mem
- **Agent Memory Paper List**: github.com/Shichun-Liu/Agent-Memory-Paper-List

This memory research skill provides a scientifically-grounded foundation for advanced agent memory systems that go beyond simple file storage.