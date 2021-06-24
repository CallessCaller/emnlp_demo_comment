from __future__ import absolute_import

# for flutter
import sys, pickle
sys.path.append('/hdd/user16/HT/webdemo/')
from flask import Flask, render_template, jsonify, request
from flask_cors import CORS, cross_origin
app = Flask(__name__)
CORS(app)
#sys.path.append("C:\\Users\\dilab\\Desktop\\webdemo\\")
from models.classifier import *
from models.build_vocab import convert_token2idx, add_padding

import os, argparse
import numpy as np
from konlpy.tag import Mecab
import torch
import torch.nn.functional as F
from torch.autograd import Variable
from torch.utils.data import TensorDataset, DataLoader


os.environ["CUDA_VISIBLE_DEVICES"] = "0"

app = Flask(__name__, static_url_path='', template_folder='template')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def load_environment():
    parser = argparse.ArgumentParser()
    parser.add_argument('--model_direc', default='../ckpt/setting1.pth', dest='model')
    vocab_file = "../ckpt/vocab"  # parser.parse_args().vocab[0]

    cfg = Config()
    tokenizer = Mecab()
    vocab = pickle.load(open(vocab_file, "rb"))

    model = SentenceCnn("senti", 30000, 300, [2, 3, 4], [80] * 3, 0.5, torch.device('cpu'))

    model_params =  parser.parse_args().model

    model.eval()
    checkpoint = torch.load(model_params, map_location=torch.device('cpu'))
    model.load_state_dict(checkpoint["model_state_dict"])
    return model, tokenizer, vocab


def inference(model, tokenizer, vocab, user_input):
    tokenized = tokenizer.morphs(user_input)
    tokenized = list(convert_token2idx(tokenized, vocab))
    tokenized_x = add_padding(tokenized, min(len(tokenized) + 10, 100), 0)

    x = Variable(torch.LongTensor(tokenized_x))#.cuda()
    y = Variable(torch.LongTensor([[0, 0]]))#.cuda()
    test_loader = DataLoader(TensorDataset(x, y), batch_size=1)
    
    result = []
    for x, y in test_loader:
        pred = model.forward(x)

        for i in range(2): # 1) Abusive detection 2) Sentiment analysis
            _, top_pred = torch.topk(pred[i], k=1, dim=-1)
            top_pred = top_pred.squeeze(dim=1)
            result.append(top_pred.detach().cpu())
        
        dang = [F.softmax(i,dim=1).detach().cpu().numpy().squeeze() for i in pred]
        toxic = "Toxic" if result[0]==0 else "Non-Toxic"
        toxic_probs = dang[0][result[0]] * 100
        sentiment = {0: 'Neg', 1: 'Neutral', 2: 'Pos'}[int(result[1])]
        sentiment_probs = dang[1][result[1]] * 100
        
        L = result[1][0] 
        offensive_score =  (np.exp(dang[1][L] * (-L) - np.exp(dang[0][0]))) / 41.25 * 100 # 일단 만들어놓은 공식 따름.
        
    return toxic, toxic_probs, sentiment, sentiment_probs, offensive_score

@app.route("/cls", methods=["GET","POST"])
@cross_origin()
def mrc_predict():
    text = request.args.get('text', '')
    print(f"text : {text}")
    koas, tokenizer, vocab = load_environment()
    abusive, abusive_score, sentiment, sentiment_score, offensive_score = inference(koas, tokenizer, vocab, text) 
    offensive_score = offensive_score.item()
    abusive_score, sentiment_score, offensive_score = str(abusive_score)[:5], str(sentiment_score)[:5], str(offensive_score * 100)[:5]
    
    print(f"abusive   : {abusive} / {abusive_score}")
    print(f"sentiment : {sentiment} / {sentiment_score}")
    print(f"offensive : {offensive_score}")

    return jsonify(result={'abusive': abusive, 'abusive_score': abusive_score,
        'sentiment': sentiment, 'sentiment_score': sentiment_score, 
        'offensive_score': offensive_score})

@app.route("/")
def home():
    a = request.args.get('text', '')

    return render_template('home.html')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)
