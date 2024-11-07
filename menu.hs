-- Integrantes: Bruno Panizzi, Enzo Vivian, Gustavo Amaro
--
-- TODO: adicionar duração de cada item
-- e  calcular a duração total do kit
import System.IO
import Text.Read (readMaybe)
import System.Exit (exitFailure)

-- definir o tipo Item
data Item = Item {nome :: String, preco :: Int} deriving Show

main :: IO ()
main = do
    putStrLn "Bem-vindo ao Kit de Sobrevivência Espacial!"
    menu []


-- string to int
strToInt :: String -> IO Int
strToInt  s = case readMaybe s of
		Just n  -> return n
		Nothing -> do
				putStrLn "Erro: Número inválido"
				exitFailure

-- o menu
menu :: [Item] -> IO ()
menu itens = do
    putStrLn "\nMenu Principal:"
    putStrLn "1. Adicionar item ao kit"
    putStrLn "2. Listar todos os itens no kit"
    putStrLn "3. Remover item do kit"
    putStrLn "4. Calcular custo total do kit"
    putStrLn "5. Sair da aplicação"
    putStr "Escolha uma opção: ";
		hFlush stdout
    opcao <- getLine
    case opcao of
        "1" -> adicionarItem itens
        "2" -> listarItens itens
        "3" -> removerItem itens
        "4" -> calcularCusto itens
        "5" -> putStrLn "Encerrando a aplicação. Até logo!"
        _   -> do
            putStrLn "Opção inválida. Tente novamente."
            menu itens

-- add item ao kit
adicionarItem :: [Item] -> IO ()
adicionarItem itens = do
    putStr "Nome do item: ";
		hFlush stdout
    nome <- getLine
    putStr "Preço do item: ";
		hFlush stdout
    precoStr <- getLine
    preco <- strToInt precoStr
		-- TODO: não crashar o app
    let novoItem = Item nome preco
    putStrLn "Item adicionado com sucesso!"
    menu (novoItem : itens)

-- Listar todos os itens no kit
listarItens :: [Item] -> IO ()
listarItens [] = do
    putStrLn "O kit está vazio."
    menu []
listarItens itens = do
    putStrLn "Itens no kit:"
    mapM_ (\(i, Item nome preco) -> putStrLn (show i ++ ". " ++ nome ++ " - " ++ show preco ++ " pilas")) (zip [1..] itens)
    menu itens

-- Remover um item do kit
removerItem :: [Item] -> IO ()
removerItem [] = do
    putStrLn "O kit está vazio. Nada para remover."
    menu []
removerItem itens = do
    putStrLn "Itens no kit:"
    mapM_ (\(i, Item nome preco) -> putStrLn (show i ++ ". " ++ nome ++ " - " ++ show preco ++ " pilas")) (zip [1..] itens)
    putStr "Digite o número do item a ser removido: ";
    hFlush stdout
    indiceStr <- getLine
    let indice = read indiceStr :: Int
    if indice > 0 && indice <= length itens
        then do
            let novosItens = take (indice - 1) itens ++ drop indice itens
            putStrLn "Item removido com sucesso!"
            menu novosItens
        else do
            putStrLn "Índice inválido. Tente novamente."
            removerItem itens

-- custo total do kit
calcularCusto :: [Item] -> IO ()
calcularCusto itens = do
    let total = sum (map preco itens)
    putStrLn ("Custo total do kit: " ++ show total ++ " créditos")
    menu itens